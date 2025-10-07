#!/usr/bin/env bash
# list_all_packages.sh by @irfnrdh
# Mengumpulkan semua daftar paket/aplikasi dari semua package manager umum di Manjaro Linux.
# Termasuk pacman, pamac, AUR, flatpak (terpasang & remote), snap, pip, npm, gem, cargo, brew, conda, AppImage, dll.
# Output disimpan ke folder ./all-installed-<timestamp>/

set -euo pipefail
OUTDIR="./all-installed-$(date +%Y%m%d_%H%M%S)"
mkdir -p "$OUTDIR"

log() { echo -e "\033[1;36m$*\033[0m"; }

run_and_save() {
  local name="$1"; shift
  local outfile="$OUTDIR/${name}.txt"
  log "🟢 ${name}..."
  {
    echo ">>> Command: $*"
    "$@" 2>&1 || echo "(command exited non-zero)"
  } > "$outfile"
  log "   ↳ hasil: $outfile"
}

### PACMAN & PAMAC ###
if command -v pacman >/dev/null; then
  run_and_save "pacman-all" pacman -Q
  run_and_save "pacman-explicit" pacman -Qe
  run_and_save "pacman-foreign" pacman -Qm
  run_and_save "pacman-repos" pacman -Sl
fi

if command -v pamac >/dev/null; then
  run_and_save "pamac-installed" pamac list --installed --no-paging
  run_and_save "pamac-available" pamac list --available --no-paging
fi

### AUR HELPERS ###
for aurmgr in yay paru trizen pikaur; do
  if command -v "$aurmgr" >/dev/null; then
    run_and_save "${aurmgr}-installed" "$aurmgr" -Q
    run_and_save "${aurmgr}-repos" "$aurmgr" -Sl
  fi
done

### FLATPAK ###
if command -v flatpak >/dev/null; then
  run_and_save "flatpak-installed" flatpak list --app --columns=name,application,version,origin
  run_and_save "flatpak-remote-refs" flatpak remote-ls --app --columns=remote,ref,name,version,branch
  run_and_save "flatpak-remotes" flatpak remotes
fi

### SNAP ###
if command -v snap >/dev/null; then
  run_and_save "snap-installed" snap list
  run_and_save "snap-available" snap find ""
  run_and_save "snap-info" snap info core || true
fi

### PYTHON ###
if command -v pip3 >/dev/null; then run_and_save "pip3-list" pip3 list; fi
if command -v pip >/dev/null; then run_and_save "pip-list" pip list; fi
if command -v pipx >/dev/null; then run_and_save "pipx-list" pipx list; fi

### NODE.JS ###
if command -v npm >/dev/null; then
  run_and_save "npm-global" npm -g ls --depth=0
  run_and_save "npm-registry" npm search "" --json || true
fi
if command -v yarn >/dev/null; then
  run_and_save "yarn-global" yarn global list --depth=0
fi
if command -v pnpm >/dev/null; then
  run_and_save "pnpm-global" pnpm ls -g --depth=0
fi

### RUBY ###
if command -v gem >/dev/null; then
  run_and_save "gem-installed" gem list --local
  run_and_save "gem-available" gem search --remote ""
fi

### RUST ###
if command -v cargo >/dev/null; then
  run_and_save "cargo-installed" cargo install --list
  run_and_save "cargo-search" cargo search a
fi

### GO ###
if command -v go >/dev/null; then
  run_and_save "go-installed" go list -m all
fi

### HOMEBREW ###
if command -v brew >/dev/null; then
  run_and_save "brew-formulae" brew list --formula
  run_and_save "brew-casks" brew list --cask || true
  run_and_save "brew-search" brew search ""
fi

### CONDA ###
if command -v conda >/dev/null; then
  run_and_save "conda-envs" conda env list
  run_and_save "conda-list" conda list
fi

### APPIMAGE ###
run_and_save "appimage-files" bash -c 'find "$HOME" /opt /usr/local/bin -type f -iname "*.AppImage" 2>/dev/null'

### DESKTOP ENTRY (GUI APPS) ###
run_and_save "desktop-apps" bash -c 'find /usr/share/applications ~/.local/share/applications -name "*.desktop" -exec basename {} \; 2>/dev/null | sort -u'

### FLATPAK RUNTIME (optional) ###
if command -v flatpak >/dev/null; then
  run_and_save "flatpak-runtimes" flatpak list --runtime --columns=name,application,version,origin
fi

### KUMPULKAN SEMUA ###
log "🔧 Menggabungkan semua hasil..."
cat "$OUTDIR"/*.txt > "$OUTDIR/all-installed.txt"

if command -v python3 >/dev/null; then
  PYOUT="$OUTDIR/all-installed.json"
  python3 - <<'PYCODE'
import json,glob,os
out={}
for path in sorted(glob.glob(os.path.join(os.getenv("OUTDIR","."),"*.txt"))):
    name=os.path.splitext(os.path.basename(path))[0]
    try:
        with open(path,'r',encoding='utf-8',errors='ignore') as f:
            lines=[l.strip() for l in f if l.strip()]
    except Exception as e:
        lines=[f"__error__: {e}"]
    out[name]=lines
with open(os.path.join(os.getenv("OUTDIR","."),"all-installed.json"),'w',encoding='utf-8') as f:
    json.dump(out,f,indent=2,ensure_ascii=False)
PYCODE
  log "✅ JSON dibuat: $PYOUT"
fi

log "🎉 Semua daftar paket tersimpan di: $OUTDIR"
