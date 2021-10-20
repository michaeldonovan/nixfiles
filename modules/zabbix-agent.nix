{ config, pkgs, ... }:
{
  services.zabbixAgent = {
    enable = true;
    server = "192.168.0.0/16";
    settings = {
      Hostname = "${config.networking.hostName}";
      ServerActive = "zabbix.localdomain";
    };
  };
}
