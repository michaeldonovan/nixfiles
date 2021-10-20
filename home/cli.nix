{ config, pkgs, ... }:

{
  imports = [
    ./fish.nix
    ./ssh.nix
    ./git.nix
  ];
  home.packages = with pkgs; [
    spacevim
    wget
    ripgrep
    git
    hub
    mosh
    fasd
    python
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

    cmake
    colormake
    gnumake
    pkg-config
    gcc
  ];

  programs.htop.enable = true;
  programs.tmux.enable = true;
  programs.vim.enable = true;
  programs.neovim = {
    enable = true;
    vimAlias = true;
    withPython3 = true;
  };

  # dotfiles
  home.file.".SpaceVim.d" = {
    recursive = true;
    source = ../../../SpaceVim.d;
  };
  home.file.".clang-format".source = ../../../.clang-format;
  home.file.".tmux.conf".source = ../../../.tmux.conf;

  home.sessionVariables = {
    DO_NOT_TRACK = 1;
    VCPKG_DISABLE_METRICS = 1;
  };
}
