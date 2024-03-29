{ config, pkgs, inputs, ... }:

{
  home.username = "cult";
  home.homeDirectory = "/home/cult";

  programs.neovim = {
    enable = true;
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
      alias commit-os="pushd ~/nixos-config; git commit -a; popd"
      alias rebuild-os="doas nixos-rebuild switch --flake ~/nixos-config#thing && commit-os"
      alias push-os="pushd ~/nixos-config; git push; popd"
      alias clear="clear && pfetch"
      pfetch
      starship init fish | source 
    '';
  };

  home.packages = with pkgs; [
    firefox
    pfetch
    gnome-extension-manager
    blackbox-terminal
    vesktop
    nix-index
  ];

  home.stateVersion = "23.11";
}
