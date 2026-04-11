{ config, pkgs, ... }:

let
  direnvPackage =
    if pkgs.stdenv.isDarwin then
      pkgs.direnv.overrideAttrs (_: {
        # direnv's fish test suite is currently unreliable on Darwin here and
        # blocks local darwin-rebuilds.
        doCheck = false;
      })
    else
      pkgs.direnv;
in

{
  imports = [
    ./fish.nix
    ./git.nix
    ./vim.nix
    ./tmux.nix
    ./starship.nix
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
    rustup
    lazygit
    lazydocker
    keybase
    tea
    gcc
    fd
    nix-prefetch-github
    sysbench
    pkg-config
    jq
    regclient
    nixfmt
  ];

  programs.htop.enable = true;

  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
    package = direnvPackage;
  };

  home.sessionVariables = {
    DO_NOT_TRACK = 1;
    VCPKG_DISABLE_METRICS = 1;
  };
}
