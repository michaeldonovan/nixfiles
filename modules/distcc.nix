{ config, pkgs, ... }:
{
  services.distccd = {
    enable = true;
    allowedClients = [
      "127.0.0.1"
      "192.168.1.0/24"
    ];
    nice = 20;
    stats.enable = true;
    openFirewall = true;
    zeroconf = true;
  };
}

