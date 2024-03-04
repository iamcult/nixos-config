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
      cursor = {
        color = "191724 e0def4";
      };
      colors = {
        background = "191724";
        foreground = "e0def4";
        regular0 = "26233a";  # black (Overlay)
        regular1 = "eb6f92";  # red (Love)
        regular2 = "31748f";  # green (Pine)
        regular3 = "f6c177";  # yellow (Gold)
        regular4 = "9ccfd8";  # blue (Foam)
        regular5 = "c4a7e7";  # magenta (Iris)
        regular6 = "ebbcba";  # cyan (Rose)
        regular7 = "e0def4";  # white (Text)
        bright0 = "6e6a86";   # bright black (Overlay)
        bright1 = "eb6f92";   # bright red (Love)
        bright2 = "31748f";   # bright green (Pine)
        bright3 = "f6c177";   # bright yellow (Gold)
        bright4 = "9ccfd8";   # bright blue (Foam)
        bright5 = "c4a7e7";   # bright magenta (Iris)
        bright6 = "ebbcba";   # bright cyan (Rose)
        bright7 = "e0def4";   # bright white (Text)
      };
    };
  };

  dconf = {
    enable = true;
    settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
      };
    };
  };

  gtk = {
    enable = true;
    theme = {
      name = "Rose-Pine";
      package = pkgs.rose-pine-gtk-theme;
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

  programs.starship.enable = true;
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting # Disable greeting
      alias nixos-version="nix profile history --profile /nix/var/nix/profiles/system | tail -2 | grep Version | rev | cut -c 20- | rev"
      alias rebuild-os="doas nixos-rebuild switch --flake ~/nixos-config#thing && pushd ~/nixos-config; git commit -a; popd"
      alias clear="clear && pfetch"
      pfetch
      starship init fish | source 
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
    pfetch
  ];

  home.stateVersion = "23.11";
}
