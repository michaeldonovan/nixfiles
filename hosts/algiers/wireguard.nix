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
          allowedIPs = [ "10.100.0.2/32" ];
        }
      ];
    };
    wg1 = {
      ips = [ "10.101.0.1/24" ];

      listenPort = 51821;

      postSetup = ''
        ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s 10.101.0.0/24 -o enp1s0 -j MASQUERADE
      '';

      postShutdown = ''
        ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s 10.101.0.0/24 -o enp1s0 -j MASQUERADE
      '';

      privateKeyFile = "/secrets/wireguard-keys/private";

      peers = [
        {
          publicKey = "fNyNlQSDREYWPJn1d61SeQU/rQx+jdapFpdM02aQ130=";
          allowedIPs = [ "10.101.0.2/32" ];
        }
      ];
    };
  };
}
