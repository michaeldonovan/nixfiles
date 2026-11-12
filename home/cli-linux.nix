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
    parted
    fio
    nodejs
    nono
    openssl
  ];

  services.gpg-agent = {
    enable = true;
    defaultCacheTtl = 1800;
    enableSshSupport = true;
  };
}
