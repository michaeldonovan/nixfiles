{ config, pkgs, ... }:

{
  imports = [
    ./fish.nix
    ./git.nix
    ./vim.nix
    ./python.nix
  ];
  home.packages = with pkgs; [
    wget
    ripgrep
    git
    hub
    mosh
    fasd
    tree
    tig
    nmap
    iperf3
    iftop
    unzip
    gnupg
    zip
    mtr
    ruby
    bind
    wakeonlan
    yubikey-manager
    yubikey-personalization
    gh
    pre-commit
    rsync
    cargo
  ];

  programs.htop.enable = true;
  programs.tmux.enable = true;

  home.sessionVariables = {
    DO_NOT_TRACK = 1;
    VCPKG_DISABLE_METRICS = 1;
  };
}
