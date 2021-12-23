{ config, pkgs, ... }:
let
  port = 51820;
in
{
  # networking.nat.enable = true;
  # networking.nat.externalInterface = "enp1s0";
  # networking.nat.internalInterfaces = [ "wg0" ];
  networking.firewall = {
    allowedUDPPorts = [ port ];
  };

  networking.wireguard.interfaces = {
    wg0 = {
      ips = [ "10.100.0.1/24" ];

      listenPort = port;

      privateKeyFile = "/secrets/wireguard-keys/private";

      peers = [
        {
          publicKey = "jYhfXlZs/VdV0XQxQrxdS8JbdEso/ACTfhShpEDkqz4=";
          allowedIPs = [ "10.100.0.1/32" ];
        }
      ];
    };
  };
}
