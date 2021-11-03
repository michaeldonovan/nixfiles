{ config, pkgs, ... }:
{
  imports = [
    ./cli.nix
  ];

  home.packages = with pkgs; [
    iotop
    hddtemp
    ansible
    mediainfo
    nixops
  ];

  services.gpg-agent = {
    enable = true;
    defaultCacheTtl = 1800;
    enableSshSupport = true;
  };
}
