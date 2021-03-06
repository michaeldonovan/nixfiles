{ config, pkgs, ... }:
{
  networking.firewall = {
    allowedTCPPorts = [ 10050 ];
  };
  services.zabbixAgent = {
    enable = true;
    server = "zabbix.localdomain";
    settings = {
      Hostname = "${config.networking.hostName}";
      ServerActive = "zabbix.localdomain";
    };
  };
}
