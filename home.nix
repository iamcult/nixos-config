{ config, pkgs, inputs, ... }:

{
  home.username = "cult";
  home.homeDirectory = "/home/cult";

  xdg.portal = {
    enable = true;
    # gtk portal needed to make gtk apps happy
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    configPackages = [ pkgs.xdg-desktop-portal-gtk ];
  };

  services.gnome-keyring.enable = true;

  wayland.windowManager.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    config = rec {
      output.eDP-1 = {
        scale = "1.5";
      };
      input."2362:628:PIXA3854:00_093A:0274_Touchpad" = {
        natural_scroll = "enabled";
      };
      modifier = "Mod4";
      terminal = "foot";
      menu = "bemenu-run";
      startup = [
        {command = "librewolf";}
      ];
    };
  };

  fonts.fontconfig.enable = true;

  programs.foot = {
    enable = true;
    settings = {
      main = {
        font = "FiraCode Nerd Font Mono Light:size=11";
      };
    };
  };

  programs.swaylock = {
    enable = true;
    package = pkgs.swaylock-effects;
  };

  programs.git = {
    enable = true;
    userName = "iamcult";
    userEmail = "101368650+iamcult@users.noreply.github.com";
    extraConfig = {
      # Sign all commits using ssh key
      commit.gpgsign = true;
      gpg.format = "ssh";
      user.signingkey = "~/.ssh/id_ed25519.pub";
    };
  };

  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting # Disable greeting
      alias nixos-version="nix profile history --profile /nix/var/nix/profiles/system | tail -2 | grep Version | rev | cut -c 20- | rev"
      alias rebuild-os="doas nixos-rebuild switch --flake ~/nixos-config#thing; pushd ~/nixos-config; git commit -a; popd" 
    '';
  };

  home.packages = with pkgs; [
    librewolf
    bemenu
    mako
    wayland
    xdg-utils
    swayidle
    grim
    slurp
    wl-clipboard
    swaybg
  ];

  home.stateVersion = "23.11";
}
