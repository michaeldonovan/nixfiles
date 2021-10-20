{ config, pkgs, ... }:

{
  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.enableIPv6 = false;
  networking.interfaces.enp8s0.useDHCP = true;

  networking.bonds = {
    "bond0" = {
      interfaces = [ "enp9s0" "enp8s0" ];
      driverOptions = {
        mode = "active-backup";
        miimon = "100";
        primary = "enp9s0";
      };
    };
  };

  networking.interfaces.bond0 = {
    useDHCP = false;
    wakeOnLan.enable = true;
    ipv4.addresses = [{
      address = "192.168.1.220";
      prefixLength = 24;
    }];
  };

  networking.defaultGateway = "192.168.1.1";
  networking.nameservers = [ "192.168.1.1" ];

  services.mullvad-vpn.enable = true;
}
