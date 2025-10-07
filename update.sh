#!/usr/bin/env bash
# manjaro-upgrade-pro.sh
# Professional System Upgrade Manager for Manjaro/Arch
# Features: Interactive mode, safety checks, rollback support, conflict resolution
# Author: @irfnrdh | License: MIT

set -o pipefail

# ============================================================================
# CONFIGURATION
# ============================================================================
VERSION="2.0.0"
LOGDIR="$HOME/.system-upgrade-logs"
LOGFILE="$LOGDIR/upgrade_$(date +%Y%m%d_%H%M%S).log"
TMPERR="/tmp/pacman_error_$$.log"
BACKUP_DIR="$HOME/.system-upgrade-backups"
CONFIG_FILE="$HOME/.config/system-upgrade.conf"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color
BOLD='\033[1m'

# Default settings (can be overridden by config file)
INTERACTIVE_MODE=true
AUTO_REMOVE_CONFLICTS=false
CREATE_BACKUP=true
CLEAN_CACHE_AFTER=true
UPDATE_AUR=true
UPDATE_FLATPAK=true
UPDATE_SNAP=true
DRY_RUN=false

# ============================================================================
# HELPER FUNCTIONS
# ============================================================================
mkdir -p "$LOGDIR" "$BACKUP_DIR"

print_header() {
    echo -e "\n${BOLD}${CYAN}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BOLD}${CYAN}║${NC}  ${BOLD}Manjaro/Arch System Upgrade Manager Pro v${VERSION}${NC}      ${BOLD}${CYAN}║${NC}"
    echo -e "${BOLD}${CYAN}╚════════════════════════════════════════════════════════════╝${NC}\n"
}

log() {
    local level="$1"
    shift
    local msg="$*"
    local timestamp="[$(date +'%F %T')]"
    
    case "$level" in
        INFO)  echo -e "${timestamp} ${BLUE}[INFO]${NC} $msg" | tee -a "$LOGFILE" ;;
        SUCCESS) echo -e "${timestamp} ${GREEN}[✓]${NC} $msg" | tee -a "$LOGFILE" ;;
        WARN)  echo -e "${timestamp} ${YELLOW}[⚠]${NC} $msg" | tee -a "$LOGFILE" ;;
        ERROR) echo -e "${timestamp} ${RED}[✗]${NC} $msg" | tee -a "$LOGFILE" ;;
        STEP)  echo -e "\n${BOLD}${MAGENTA}▶${NC} ${BOLD}$msg${NC}" | tee -a "$LOGFILE" ;;
    esac
}

ask_user() {
    local prompt="$1"
    local default="${2:-n}"
    
    if [[ "$INTERACTIVE_MODE" == false ]]; then
        [[ "$default" == "y" ]] && return 0 || return 1
    fi
    
    local answer
    echo -ne "${YELLOW}[?]${NC} $prompt [y/N]: "
    read -r answer
    answer="${answer:-$default}"
    [[ "${answer,,}" =~ ^y(es)?$ ]]
}

run_cmd() {
    local cmd="$*"
    log INFO "Executing: $cmd"
    if [[ "$DRY_RUN" == true ]]; then
        log WARN "DRY RUN - Command not executed"
        return 0
    fi
    eval "$cmd" 2>&1 | tee -a "$LOGFILE"
    return "${PIPESTATUS[0]}"
}

detect_managers() {
    declare -gA MGR
    local managers=(pacman pamac yay paru flatpak snap npm pip)
    
    log STEP "Detecting package managers..."
    for mgr in "${managers[@]}"; do
        if command -v "$mgr" >/dev/null 2>&1; then
            MGR[$mgr]=1
            log SUCCESS "Found: $mgr"
        fi
    done
    
    if [[ ${#MGR[@]} -eq 0 ]]; then
        log ERROR "No package managers detected!"
        exit 1
    fi
}

create_system_snapshot() {
    log STEP "Creating system snapshot..."
    
    local snapshot_file="$BACKUP_DIR/pkglist_$(date +%Y%m%d_%H%M%S).txt"
    
    if [[ ${MGR[pacman]+_} ]]; then
        pacman -Qqe > "$snapshot_file"
        log SUCCESS "Package list saved to: $snapshot_file"
    fi
    
    # Backup important configs
    if ask_user "Backup /etc/pacman.conf and mirrorlist?" "y"; then
        cp /etc/pacman.conf "$BACKUP_DIR/pacman.conf.backup" 2>/dev/null || true
        cp /etc/pacman.d/mirrorlist "$BACKUP_DIR/mirrorlist.backup" 2>/dev/null || true
        log SUCCESS "Configuration files backed up"
    fi
}

check_disk_space() {
    log STEP "Checking disk space..."
    
    local root_avail=$(df -h / | awk 'NR==2 {print $4}')
    local cache_size=$(du -sh /var/cache/pacman/pkg 2>/dev/null | cut -f1)
    
    log INFO "Available space on /: $root_avail"
    log INFO "Package cache size: ${cache_size:-Unknown}"
    
    # Check if less than 2GB available
    local avail_mb=$(df -m / | awk 'NR==2 {print $4}')
    if [[ $avail_mb -lt 2048 ]]; then
        log WARN "Low disk space detected (< 2GB)"
        if ask_user "Clean package cache now?" "y"; then
            run_cmd "sudo pacman -Sc --noconfirm"
        fi
    fi
}

check_updates_available() {
    log STEP "Checking for available updates..."
    
    local updates_found=false
    
    if [[ ${MGR[pacman]+_} ]]; then
        if command -v checkupdates >/dev/null 2>&1; then
            local pkg_updates=$(checkupdates 2>/dev/null | wc -l)
            if [[ $pkg_updates -gt 0 ]]; then
                log INFO "Official repositories: $pkg_updates packages"
                updates_found=true
            fi
        fi
    fi
    
    if [[ ${MGR[yay]+_} ]] && [[ "$UPDATE_AUR" == true ]]; then
        local aur_updates=$(yay -Qua 2>/dev/null | wc -l)
        if [[ $aur_updates -gt 0 ]]; then
            log INFO "AUR packages: $aur_updates packages"
            updates_found=true
        fi
    fi
    
    if [[ ${MGR[flatpak]+_} ]] && [[ "$UPDATE_FLATPAK" == true ]]; then
        local flatpak_updates=$(flatpak remote-ls --updates 2>/dev/null | wc -l)
        if [[ $flatpak_updates -gt 0 ]]; then
            log INFO "Flatpak apps: $flatpak_updates packages"
            updates_found=true
        fi
    fi
    
    if [[ "$updates_found" == false ]]; then
        log SUCCESS "System is up to date!"
        return 1
    fi
    
    return 0
}

check_for_partial_upgrades() {
    log STEP "Checking for partial upgrades..."
    
    # Critical: Detect if system has mixed old/new libraries
    if [[ ${MGR[pacman]+_} ]]; then
        local foreign_libs=$(ldd /usr/bin/* 2>/dev/null | grep "not found" | wc -l)
        if [[ $foreign_libs -gt 0 ]]; then
            log ERROR "Detected broken library links! System may be partially upgraded."
            log WARN "This usually happens after incomplete upgrades or power failures."
            log INFO "Recommendation: Full system upgrade with -Syyu is REQUIRED"
            
            if ask_user "Try emergency system recovery?" "y"; then
                run_cmd "sudo pacman -Syyu --noconfirm"
            fi
            return 1
        fi
    fi
    return 0
}

check_mirror_health() {
    log STEP "Checking mirror health..."
    
    if [[ ${MGR[pacman]+_} ]]; then
        # Check if mirrors are accessible
        if ! curl -s --connect-timeout 5 https://archlinux.org > /dev/null; then
            log WARN "Cannot reach Arch mirrors. Check internet connection."
        fi
        
        # For Manjaro: check if mirrors need refresh
        if command -v pacman-mirrors >/dev/null 2>&1; then
            local mirror_age=$(find /var/lib/pacman-mirrors -name "status.json" -mtime +30 2>/dev/null | wc -l)
            if [[ $mirror_age -gt 0 ]]; then
                log WARN "Mirrors list is older than 30 days"
                if ask_user "Update Manjaro mirrors?" "y"; then
                    run_cmd "sudo pacman-mirrors --fasttrack && sudo pacman -Syy"
                fi
            fi
        fi
    fi
}

refresh_keyrings() {
    log STEP "Refreshing package keyrings..."
    
    if [[ ${MGR[pacman]+_} ]]; then
        # Check if keyring is corrupted
        if ! sudo pacman-key --list-keys >/dev/null 2>&1; then
            log ERROR "Keyring appears corrupted!"
            if ask_user "Reinitialize keyring? (May take several minutes)" "y"; then
                run_cmd "sudo rm -rf /etc/pacman.d/gnupg"
                run_cmd "sudo pacman-key --init"
                run_cmd "sudo pacman-key --populate archlinux manjaro"
            fi
        fi
        
        if ask_user "Refresh Arch/Manjaro keyrings?" "n"; then
            run_cmd "sudo pacman -Sy archlinux-keyring manjaro-keyring --noconfirm --needed" || true
            run_cmd "sudo pacman-key --populate archlinux manjaro" || true
            run_cmd "sudo pacman-key --refresh-keys" || true
        fi
    fi
}

perform_system_upgrade() {
    log STEP "Performing system upgrade..."
    
    local upgrade_cmd=""
    local mgr_name=""
    
    # Priority: pamac > yay > paru > pacman
    if [[ ${MGR[pamac]+_} ]]; then
        mgr_name="pamac"
        upgrade_cmd="sudo pamac upgrade --no-confirm"
    elif [[ ${MGR[yay]+_} ]]; then
        mgr_name="yay"
        upgrade_cmd="yay -Syu --noconfirm"
    elif [[ ${MGR[paru]+_} ]]; then
        mgr_name="paru"
        upgrade_cmd="paru -Syu --noconfirm"
    else
        mgr_name="pacman"
        upgrade_cmd="sudo pacman -Syu --noconfirm"
    fi
    
    log INFO "Using $mgr_name for system upgrade..."
    
    if ! eval "$upgrade_cmd" 2>"$TMPERR" | tee -a "$LOGFILE"; then
        log ERROR "Upgrade failed with $mgr_name"
        return 1
    else
        log SUCCESS "System upgrade completed successfully"
        return 0
    fi
}

parse_and_fix_conflicts() {
    log STEP "Analyzing package conflicts..."
    
    if [[ ! -s "$TMPERR" ]]; then
        log INFO "No errors to analyze"
        return 0
    fi
    
    # Display error summary
    log WARN "Errors detected during upgrade:"
    tail -n 30 "$TMPERR" | tee -a "$LOGFILE"
    
    # Parse conflicts
    local conflicts=$(grep -oP "required by \K[^\n']+" "$TMPERR" 2>/dev/null | sed 's/[:,]$//' | sort -u)
    
    if [[ -z "$conflicts" ]]; then
        log WARN "No explicit package conflicts found in error output"
        
        # Check for file conflicts
        if grep -q "exists in filesystem" "$TMPERR"; then
            log WARN "File conflicts detected"
            if ask_user "Try to resolve file conflicts with --overwrite?" "n"; then
                log INFO "Re-running upgrade with --overwrite..."
                if [[ ${MGR[pacman]+_} ]]; then
                    run_cmd "sudo pacman -Syu --overwrite '*' --noconfirm"
                fi
            fi
        fi
        return 1
    fi
    
    log INFO "Conflicting packages found:"
    echo "$conflicts" | while read -r pkg; do
        echo "  • $pkg"
    done | tee -a "$LOGFILE"
    
    # Handle each conflict
    for pkg in $conflicts; do
        handle_conflict_package "$pkg"
    done
    
    # Retry upgrade
    log STEP "Retrying system upgrade after conflict resolution..."
    perform_system_upgrade
}

handle_conflict_package() {
    local pkg="$1"
    
    log INFO "Handling conflict: $pkg"
    
    # Try to identify problematic libraries
    local libs=$(grep -i "$pkg" "$TMPERR" 2>/dev/null | \
                 grep -oP "'\K[^']+(?='.*required by)" | \
                 sort -u)
    
    if [[ -n "$libs" ]]; then
        log INFO "Required libraries for $pkg:"
        echo "$libs" | while read -r lib; do
            echo "  • $lib"
        done | tee -a "$LOGFILE"
    fi
    
    # Strategy 1: Try to rebuild AUR package
    if [[ ${MGR[yay]+_} ]] || [[ ${MGR[paru]+_} ]]; then
        if pacman -Qm "$pkg" >/dev/null 2>&1; then
            if ask_user "Rebuild AUR package '$pkg'?" "y"; then
                if [[ ${MGR[yay]+_} ]]; then
                    run_cmd "yay -S --rebuild --noconfirm $pkg" && return 0
                elif [[ ${MGR[paru]+_} ]]; then
                    run_cmd "paru -S --rebuild --noconfirm $pkg" && return 0
                fi
            fi
        fi
    fi
    
    # Strategy 2: Downgrade from cache
    if try_downgrade_from_cache "$pkg"; then
        return 0
    fi
    
    # Strategy 3: Remove package
    if [[ "$AUTO_REMOVE_CONFLICTS" == true ]] || \
       ask_user "Remove '$pkg' to resolve conflict?" "n"; then
        log WARN "Removing package: $pkg"
        run_cmd "sudo pacman -Rdd --noconfirm $pkg"
        echo "$pkg" >> "$BACKUP_DIR/removed_packages.txt"
        log INFO "Package logged for potential reinstallation"
    else
        log INFO "Skipping removal of $pkg"
    fi
}

try_downgrade_from_cache() {
    local pkg="$1"
    
    log INFO "Searching package cache for: $pkg"
    
    local cached=$(find /var/cache/pacman/pkg/ -name "${pkg}-*.pkg.tar.*" 2>/dev/null | sort -V)
    
    if [[ -z "$cached" ]]; then
        log WARN "No cached versions found"
        return 1
    fi
    
    local count=$(echo "$cached" | wc -l)
    log INFO "Found $count cached version(s)"
    
    if [[ $count -gt 1 ]]; then
        # Offer to downgrade to previous version
        local latest=$(echo "$cached" | tail -n 1)
        local previous=$(echo "$cached" | tail -n 2 | head -n 1)
        
        if ask_user "Downgrade to previous cached version?" "y"; then
            run_cmd "sudo pacman -U --noconfirm $previous"
            return $?
        fi
    fi
    
    return 1
}

update_other_managers() {
    # Flatpak
    if [[ ${MGR[flatpak]+_} ]] && [[ "$UPDATE_FLATPAK" == true ]]; then
        log STEP "Updating Flatpak applications..."
        run_cmd "flatpak update -y" || true
    fi
    
    # Snap
    if [[ ${MGR[snap]+_} ]] && [[ "$UPDATE_SNAP" == true ]]; then
        log STEP "Updating Snap applications..."
        run_cmd "sudo snap refresh" || true
    fi
    
    # NPM global packages
    if [[ ${MGR[npm]+_} ]]; then
        if ask_user "Update global NPM packages?" "n"; then
            log STEP "Updating NPM packages..."
            run_cmd "npm -g update" || true
        fi
    fi
    
    # Pip packages
    if [[ ${MGR[pip]+_} ]]; then
        if ask_user "Show outdated pip packages?" "n"; then
            log STEP "Checking pip packages..."
            pip list --outdated 2>&1 | tee -a "$LOGFILE" || true
        fi
    fi
}

perform_cleanup() {
    log STEP "System cleanup..."
    
    # Clean package cache
    if [[ "$CLEAN_CACHE_AFTER" == true ]] || ask_user "Clean package cache?" "y"; then
        run_cmd "sudo pacman -Sc --noconfirm"
    fi
    
    # Remove orphaned packages
    if ask_user "Remove orphaned packages?" "y"; then
        local orphans=$(pacman -Qtdq 2>/dev/null)
        if [[ -n "$orphans" ]]; then
            log INFO "Found orphaned packages:"
            echo "$orphans" | tee -a "$LOGFILE"
            run_cmd "sudo pacman -Rns --noconfirm $orphans"
        else
            log SUCCESS "No orphaned packages found"
        fi
    fi
    
    # Check for .pacnew/.pacsave files
    log INFO "Checking for .pacnew and .pacsave files..."
    local pacnew_files=$(find /etc -name "*.pacnew" 2>/dev/null)
    if [[ -n "$pacnew_files" ]]; then
        log WARN "Found .pacnew files that need attention:"
        echo "$pacnew_files" | tee -a "$LOGFILE"
    fi
}

verify_system_integrity() {
    log STEP "Verifying system integrity..."
    
    if [[ ${MGR[pacman]+_} ]]; then
        run_cmd "sudo pacman -Dk" || true
    fi
    
    # Check for partial upgrades
    log INFO "Checking for partial upgrades..."
    if command -v checkrebuild >/dev/null 2>&1; then
        checkrebuild 2>&1 | tee -a "$LOGFILE" || true
    fi
}

show_summary() {
    echo -e "\n${BOLD}${GREEN}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BOLD}${GREEN}║${NC}  ${BOLD}UPGRADE SUMMARY${NC}                                          ${BOLD}${GREEN}║${NC}"
    echo -e "${BOLD}${GREEN}╠════════════════════════════════════════════════════════════╣${NC}"
    echo -e "${BOLD}${GREEN}║${NC}  Log file: ${LOGFILE:0:40}${NC}"
    echo -e "${BOLD}${GREEN}║${NC}  Backup dir: ${BACKUP_DIR:0:37}${NC}"
    
    if [[ -f "$BACKUP_DIR/removed_packages.txt" ]]; then
        local removed=$(wc -l < "$BACKUP_DIR/removed_packages.txt")
        echo -e "${BOLD}${GREEN}║${NC}  Removed packages: $removed (see removed_packages.txt)${NC}"
    fi
    
    echo -e "${BOLD}${GREEN}╚════════════════════════════════════════════════════════════╝${NC}\n"
    
    log SUCCESS "System upgrade completed!"
    log INFO "Review the log file for details: $LOGFILE"
}

load_config() {
    if [[ -f "$CONFIG_FILE" ]]; then
        log INFO "Loading configuration from $CONFIG_FILE"
        source "$CONFIG_FILE"
    fi
}

show_help() {
    cat << EOF
Manjaro/Arch System Upgrade Manager Pro v${VERSION}

Usage: $0 [OPTIONS]

OPTIONS:
    -h, --help              Show this help message
    -i, --interactive       Enable interactive mode (default)
    -a, --auto              Automatic mode (no prompts)
    -d, --dry-run          Show what would be done without executing
    --no-aur               Skip AUR updates
    --no-flatpak           Skip Flatpak updates
    --no-snap              Skip Snap updates
    --no-backup            Skip creating backup
    --auto-remove          Automatically remove conflicting packages
    --config FILE          Load configuration from FILE

EXAMPLES:
    $0                     # Interactive upgrade
    $0 --auto              # Fully automatic upgrade
    $0 --dry-run           # Preview what would be done
    $0 --no-aur --no-snap  # Skip AUR and Snap updates

CONFIGURATION FILE:
    Default location: $CONFIG_FILE
    
    Example content:
        INTERACTIVE_MODE=false
        AUTO_REMOVE_CONFLICTS=true
        UPDATE_AUR=true
        UPDATE_FLATPAK=true

EOF
}

# ============================================================================
# MAIN EXECUTION
# ============================================================================
main() {
    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help) show_help; exit 0 ;;
            -i|--interactive) INTERACTIVE_MODE=true ;;
            -a|--auto) INTERACTIVE_MODE=false ;;
            -d|--dry-run) DRY_RUN=true ;;
            --no-aur) UPDATE_AUR=false ;;
            --no-flatpak) UPDATE_FLATPAK=false ;;
            --no-snap) UPDATE_SNAP=false ;;
            --no-backup) CREATE_BACKUP=false ;;
            --auto-remove) AUTO_REMOVE_CONFLICTS=true ;;
            --config) CONFIG_FILE="$2"; shift ;;
            *) log ERROR "Unknown option: $1"; show_help; exit 1 ;;
        esac
        shift
    done
    
    load_config
    print_header
    
    log INFO "Starting system upgrade process..."
    log INFO "Mode: $([ "$INTERACTIVE_MODE" == true ] && echo "Interactive" || echo "Automatic")"
    [[ "$DRY_RUN" == true ]] && log WARN "DRY RUN MODE - No changes will be made"
    
    detect_managers
    
    if [[ "$CREATE_BACKUP" == true ]]; then
        create_system_snapshot
    fi
    
    check_disk_space
    
    if ! check_updates_available; then
        exit 0
    fi
    
    if ! ask_user "Proceed with system upgrade?" "y"; then
        log INFO "Upgrade cancelled by user"
        exit 0
    fi
    
    refresh_keyrings
    
    if ! perform_system_upgrade; then
        parse_and_fix_conflicts
    fi
    
    update_other_managers
    perform_cleanup
    verify_system_integrity
    show_summary
    
    log SUCCESS "All operations completed!"
}

# Run main function
main "$@"
