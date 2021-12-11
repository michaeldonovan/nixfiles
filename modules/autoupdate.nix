{ config, pkgs, ... }:
{
  system.autoUpgrade = {
    enable = true;
    flake = "git@github.com:michaeldonovan/nixfiles.git";
    allowReboot = true;
    flags = [
      "--update-input nixpkgs"
      "--update-input home-manager"
      "--commit-lock-file"
    ];
  };
}
