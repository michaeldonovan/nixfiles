{ config, pkgs, ... }:
let
  port = 51820;
in
{
  networking.firewall = {
    allowedUDPPorts = [ port ]; # Clients and peers can use the same port, see listenport
  };

  networking.wireguard.interfaces = {
    wg_algiers = {
      ips = [ "10.100.0.3/24" ];
      listenPort = port;

      privateKeyFile = "/etc/wireguard-keys/private";

      peers = [
        {
          publicKey = "/8yr2zpi2ZwmsK0Yr2voXp5G837ZkbqqWTfFot1tDHc=";

          allowedIPs = [ "10.100.0.1/32" ];

          endpoint = "algiers.mdonovan.dev:51820";

          persistentKeepalive = 25;
        }
      ];
    };
  };
}
