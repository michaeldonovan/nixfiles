{ config, pkgs, ... }:
{
  users.users.michael = {
    shell = pkgs.fish;
    home = "/Users/michael";
  };


  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    nixVersions.stable
  ];

  # nixpkgs.config.allowUnfree = true;
  # nixpkgs.config.allowBroken = true;

  programs.gnupg.agent = {
    enable = true;
  };

  # Use a custom configuration.nix location.
  # $ darwin-rebuild switch -I darwin-config=$HOME/.config/nixpkgs/darwin/configuration.nix
  # environment.darwinConfig = "$HOME/.config/nixpkgs/darwin/configuration.nix";

  # Auto upgrade nix package and the daemon service.
  nix.package = pkgs.nix;

  system.primaryUser = "michael";

  programs.fish.enable = true;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
}
