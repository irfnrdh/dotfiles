{ config, lib, pkgs, ... }:

{
  # Konfigurasi perangkat keras untuk ThinkPad X1 Carbon Gen 6
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/your-root-uuid";
    fsType = "ext4";
  };

  swapDevices = [
    { device = "/dev/disk/by-uuid/your-swap-uuid"; }
  ];

  nixpkgs.config.allowUnfree = true;

  # Konfigurasi jaringan
  networking.hostName = "thinkpad-x1-carbon-gen6";
  networking.wireless.enable = true;
  networking.useDHCP = true;

  # Konfigurasi X11
  services.xserver.enable = true;
  services.xserver.videoDrivers = [ "intel" ];

  # Power management
  powerManagement.cpuFreqGovernor = "powersave";

  # Audio
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Sensor
  services.hwmon = {
    lm_sensors.enable = true;
    thinkpad.enable = true;
  };

  # Bluetooth
  hardware.bluetooth.enable = true;

  # Autostart
  systemd.user.services = {
    battery-notification = {
      enable = true;
      script = ''
        ${pkgs.bash}/bin/bash ${config.users.mutableUserEnvironment}/home/your-username/.config/battery_notification.sh
      '';
    };
    xautolock = {
      enable = true;
      script = ''
        ${pkgs.bash}/bin/bash ${config.users.mutableUserEnvironment}/home/your-username/Scripts/blurlock
      '';
    };
    libinput-gestures = {
      enable = true;
      script = ''
        ${pkgs.bash}/bin/bash ${config.users.mutableUserEnvironment}/home/your-username/.config/libinput-gestures.conf
      '';
    };
  };

  # Autologin
  services.xserver.displayManager.autoLogin.enable = true;
  services.xserver.displayManager.autoLogin.user = "your-username";

  # User Configuration
  users.users.your-username = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
    packages = with pkgs; [
      # Tambahkan paket tambahan untuk pengguna
    ];
  };
}
