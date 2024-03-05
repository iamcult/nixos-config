# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.supportedFilesystems = [ "zfs" ];
  boot.kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;
  networking.hostId = "e5a29261";

  hardware.opengl.enable = true;

  environment.persistence."/persist" = {
    hideMounts = true;
    files = [
      "/etc/machine-id"
    ];
    directories = [
      "/var/log"
      "/var/lib/bluetooth"
      "/var/lib/fprint"
      "/etc/NetworkManager/system-connections"
    ];
    users.cult = {
      directories = [
        "Downloads"
        "Music"
        "Pictures"
        "Documents"
        "Videos"
        "Dev"
        "nixos-config"
        ".config/dconf"
        ".config/vesktop"
        ".mozilla"
        ".local/share/fish"
        ".local/share/gnome-shell"
        ".local/share/backgrounds"
        { directory = ".ssh"; mode = "0700"; }
        { directory = ".local/share/keyrings"; mode = "0700"; }
      ];
    };
  };

  zramSwap.enable = true;

  networking.hostName = "thing"; # Define your hostname.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  time.timeZone = "America/New_York";

  age.secrets.password.file = ./secrets/password.age;

  services.fprintd.enable = true;
  security.pam.services.login.fprintAuth = false;
  security.pam.services.gdm-fingerprint.fprintAuth = true;

  users.mutableUsers = false;
  users.users.cult = {
    isNormalUser = true;
    shell = pkgs.fish;
    extraGroups = [ "wheel" "networkmanager" ]; # Enable ‘sudo’ for the user.
    hashedPasswordFile = config.age.secrets.password.path;
  };
  programs.fish.enable = true;
  programs.dconf.enable = true;

  security.doas.enable = true;
  security.sudo.enable = false;
  security.doas.extraRules = [{
  groups = ["wheel"];
    keepEnv = true;  # Optional, retains environment variables while running commands
    persist = true;  # Optional, only require password verification a single time
  }];

  environment.systemPackages = with pkgs; [
    git
  ];

  environment.gnome.excludePackages = (with pkgs; [
    gnome-tour
  ]) ++ (with pkgs.gnome; [
    gnome-music
    epiphany # web browser
    geary # email reader
    gnome-characters
    totem # video player
    yelp
    gnome-contacts
    gnome-calendar
    file-roller
    simple-scan
    gnome-shell-extensions
  ]);

  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "FiraCode" ]; })
  ];

  services.xserver = {
    enable = true;
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
  };

  hardware.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  services.openssh.enable = true;
  system.stateVersion = "24.05"; # Did you read the comment?
}

