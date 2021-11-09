{ config, pkgs, ... }:
{
  system.autoUpgrade = {
    enable = true;
    flake = "github:michaeldonovan/nixfiles";
    flags = [
      "--update-input nixpkgs"
      "--update-input home-manager"
    ];
  };
}
