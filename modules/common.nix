{ config, pkgs, lib, ... }:
{
  imports = [
    ./users.nix
  ];

  # Set your time zone.
  time.timeZone = "America/Chicago";

  nix.autoOptimiseStore = true;
  nixpkgs.config.allowUnfree = true;
  system.autoUpgrade.enable = true;

  programs.fish.enable = true;
  users.defaultUserShell = pkgs.fish;
  environment.shells = [ pkgs.fish ];
  environment.homeBinInPath = true;

  # home-manager
  home-manager.useGlobalPkgs = true;

  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    fish
    fasd
    gnupg
    nix-prefetch-scripts
    nix-index
    lsof
    lm_sensors
    cpufrequtils
    smartmontools
  ];

  services.openssh = {
    enable = true;
    passwordAuthentication = false;
  };

  programs.gnupg.agent = {
    enable = true;
  };
}
