{ config, ... }:
{
  networking.firewall = {
    allowedTCPPorts = [ 10050 ];
  };
  services.zabbixAgent = {
    enable = true;
    server = "10.100.0.2";
    settings = {
      Hostname = "${config.networking.hostName}";
    };
  };
}
