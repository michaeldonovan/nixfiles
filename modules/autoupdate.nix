{ config, pkgs, ... }:
{
  system.autoUpgrade = {
    enable = true;
    flake = "github:michaeldonovan/nixfiles";
    allowReboot = true;
    flags = [
      "--update-input nixpkgs"
      "--update-input home-manager"
      "--no-write-lock-file"
    ];
  };
}
