# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, hostname, lanAddr, vlanAddr, extraPorts, ... }:
let
  router = {
    lanAddr = "192.168.1.1";
    vlanAddr = "192.168.2.1";
  };
  lanNet = "192.168.1.0";
  prefixLength = 24;
in
{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/sda";

  boot.kernelParams = [
    "console=ttyS0,115200"
    "console=tty1"
  ];


  # Set your time zone.
  time.timeZone = "America/Chicago";

  networking = {
    hostName = hostname;
    domain = "localdomain";
    defaultGateway = router.lanAddr;
    nameservers = [ router.lanAddr ];

    interfaces.ens18 = {
      useDHCP = false;
      ipv4.addresses = [{
        address = lanAddr;
        prefixLength = prefixLength;
      }];
    };

    vlans = {
      vlan2 = {
        id = 2;
        interface = "ens18";
      };
    };

    interfaces.vlan2 = {
      useDHCP = false;
      ipv4 = {
        addresses = [{
          address = vlanAddr;
          prefixLength = prefixLength;
        }];
        routes = [{
          address = lanNet;
          prefixLength = prefixLength;
          via = router.vlanAddr;
        }];
      };
    };

    firewall = {
      allowedTCPPorts = extraPorts;
    };
  };

  environment.systemPackages = with pkgs; [
    wget
    vim
    git
  ];

  services.qemuGuest.enable = true;

  powerManagement.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.05"; # Did you read the comment?
}

