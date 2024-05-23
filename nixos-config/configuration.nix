{ config, pkgs, lib, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "your-hostname";
  networking.networkmanager.enable = true;

  time.timeZone = "Asia/Jakarta"; # Sesuaikan sesuai dengan zona waktu Anda
  i18n.defaultLocale = "en_US.UTF-8";

  services.xserver.enable = true;
  services.xserver.layout = "us";
  services.xserver.xkbOptions = "eurosign:e";
  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.windowManager.i3 = {
    enable = true;
    package = pkgs.i3-gaps; # Pastikan paket i3-gaps sudah terinstal di sistem Anda
    config = {
      # Konfigurasi i3wm Anda mulai dari sini
      set = {
        mod = "Mod4"; # Set mod key
        default_border = "pixel 1";
        default_floating_border = "normal";
        hide_edge_borders = "none";

        bindsym = {
          mod = "Mod4"; # Set mod key
          u = "border none";
          y = "border pixel 1";
          n = "border normal";
          Return = "exec alacritty"; # Start a terminal
          Shift = {
            q = "kill focused window";
          };
          d = "exec --no-startup-id rofi -show drun"; # Start program launcher
          z = "exec --no-startup-id morc_menu"; # Launch categorized menu
          Ctrl = {
            m = "exec pavucontrol"; # Sound control
          };
          p = "exec --no-startup-id ~/.config/rofi/launchers/type-7/launcher.sh"; # Rofi launcher
          j = "focus left";
          k = "focus down";
          l = "focus up";
          semicolon = "focus right";
          Left = "focus left";
          Down = "focus down";
          Up = "focus up";
          Right = "focus right";
          Shift = {
            j = "move left";
            k = "move down";
            l = "move up";
            semicolon = "move right";
            Left = "move left";
            Down = "move down";
            Up = "move up";
            Right = "move right";
          };
          b = "workspace back_and_forth";
          Shift = {
            b = "move container to workspace back_and_forth; workspace back_and_forth";
          };
          s = "layout stacking";
          w = "layout tabbed";
          e = "layout toggle split";
          space = "focus mode_toggle";
          Shift = {
            space = "floating toggle";
          };
          a = "focus parent";
          minus = "move scratchpad";
          Shift = {
            minus = "move scratchpad";
          };
          mod1 = "scratchpad show";
          1 = "workspace 1";
          2 = "workspace 2";
          3 = "workspace 3";
          4 = "workspace 4";
          5 = "workspace 5";
          6 = "workspace 6";
          7 = "workspace 7";
          8 = "workspace 8";
          Ctrl = {
            1 = "move container to workspace 1";
            2 = "move container to workspace 2";
            3 = "move container to workspace 3";
            4 = "move container to workspace 4";
            5 = "move container to workspace 5";
            6 = "move container to workspace 6";
            7 = "move container to workspace 7";
            8 = "move container to workspace 8";
          };
          Shift = {
            1 = "move container to workspace 1; workspace 1";
            2 = "move container to workspace 2; workspace 2";
            3 = "move container to workspace 3; workspace 3";
            4 = "move container to workspace 4; workspace 4";
            5 = "move container to workspace 5; workspace 5";
            6 = "move container to workspace 6; workspace 6";
            7 = "move container to workspace 7; workspace 7";
            8 = "move container to workspace 8; workspace 8";
          };
          9 = "exec --no-startup-id blurlock"; # Lock screen
          0 = "mode \"$mode_system\""; # System mode
          Shift = {
            9 = "exec --no-startup-id i3-nagbar -t warning -m 'You pressed the exit shortcut. Do you really want to exit i3? This will end your X session.' -b 'Yes, exit i3' 'i3-msg exit'";
          };
          Shift = {
            g = "mode \"$mode_gaps\"";
          };
          XF86AudioMute = "exec --no-startup-id mute_toggle";
        };

        gaps = {
          inner = 14;
          outer = -2;
        };

        smart_gaps = "on";
        smart_borders = "on";
      };

      bindsym = {
        Mod4 = "Mod4";
        j = "focus left";
        k = "focus down";
        l = "focus up";
        semicolon = "focus right";
        Left = "focus left";
        Down = "focus down";
        Up = "focus up";
        Right = "focus right";
        Shift = {
          j = "move left";
          k = "move down";
          l = "move up";
          semicolon = "move right";
          Left = "move left";
          Down = "move down";
          Up = "move up";
          Right = "move right";
        };
        1 = "workspace 1";
        2 = "workspace 2";
        3 = "workspace 3";
        4 = "workspace 4";
        5 = "workspace 5";
        6 = "workspace 6";
        7 = "workspace 7";
        8 = "workspace 8";
        Ctrl = {
          1 = "move container to workspace 1";
          2 = "move container to workspace 2";
          3 = "move container to workspace 3";
          4 = "move container to workspace 4";
          5 = "move container to workspace 5";
          6 = "move container to workspace 6";
          7 = "move container to workspace 7";
          8 = "move container to workspace 8";
        };
        Shift = {
          1 = "move container to workspace 1; workspace 1";
          2 = "move container to workspace 2; workspace 2";
          3 = "move container to workspace 3; workspace 3";
          4 = "move container to workspace 4; workspace 4";
          5 = "move container to workspace 5; workspace 5";
          6 = "move container to workspace 6; workspace 6";
          7 = "move container to workspace 7; workspace 7";
          8 = "move container to workspace 8; workspace 8";
        };
        9 = "exec --no-startup-id blurlock"; # Lock screen
        0 = "mode \"$mode_system\""; # System mode
        Shift = {
          9 = "exec --no-startup-id i3-nagbar -t warning -m 'You pressed the exit shortcut. Do you really want to exit i3? This will end your X session.' -b 'Yes, exit i3' 'i3-msg exit'";
        };
        Shift = {
          g = "mode \"$mode_gaps\"";
        };
        XF86AudioMute = "exec --no-startup-id mute_toggle";
      };
    };
  };

  environment.systemPackages = with pkgs; [
    vim
    git
    wget
    curl
    firefox
    alacritty
    rofi
    dmenu
    pavucontrol
    nitrogen
    xautolock
    blueman
    clipit
    xfce4-power-manager
    pamac-tray
    xorg.xbacklight
    i3status
    i3lock
    flameshot
    xkill
    dunst
    picom
    volumeicon
    alsa-utils # Pastikan paket ini sudah terinstal di sistem Anda
  ];

  services.xserver.displayManager.autoLogin.enable = true;
  services.xserver.displayManager.autoLogin.user = "your-username"; # Ganti dengan nama pengguna Anda

  users.users.your-username = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
    packages = with pkgs; [
      # Tambahkan paket tambahan untuk pengguna
    ];
  };

  system.stateVersion = "22.11"; # Sesuaikan dengan versi NixOS yang Anda gunakan
}

