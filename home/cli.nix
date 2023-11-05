{ config, pkgs, ... }:

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
    cargo
    thefuck
    lazygit
    lazydocker
    keybase
    tea
    gcc
    chatblade
    shell_gpt
    fd
    nix-prefetch-github
    sysbench
  ];

  programs.htop.enable = true;

  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  home.sessionVariables = {
    DO_NOT_TRACK = 1;
    VCPKG_DISABLE_METRICS = 1;
  };
}
