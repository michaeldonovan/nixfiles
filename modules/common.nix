{ config, pkgs, lib, ... }:
{
  imports = [
    ./users.nix
  ];

  # Set your time zone.
  time.timeZone = "America/Chicago";

  networking.enableIPv6 = true;

  nix.settings.auto-optimise-store = true;
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.permittedInsecurePackages = [
    "electron-9.4.4"
  ];

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
    ssh-import-id
  ];

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
  };

  programs.gnupg.agent = {
    enable = true;
  };
}
