{ config, ... }:
{
  services.zabbixAgent = {
    openFirewall = true;
    enable = true;
    server = "10.100.0.2";
    settings = {
      Hostname = "${config.networking.hostName}";
    };
  };
}
