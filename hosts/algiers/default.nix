# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:
let
  nfsOpts = "x-systemd.automount,x-systemd.idle-timeout=60,x-systemd.device-timeout=175,x-systemd.mount-timeout=5s,noauto";
  smbCredentialsFile = "/secrets/smb-secrets";
  smbOpts = "uid=1000,gid=100,credentials=${smbCredentialsFile},${nfsOpts}";
in
{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./wireguard.nix
      ./zabbix.nix
    ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  # boot.loader.grub.efiSupport = true;
  # boot.loader.grub.efiInstallAsRemovable = true;
  # boot.loader.efi.efiSysMountPoint = "/boot/efi";
  # Define on which hard drive you want to install Grub.
  # boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only

  networking.hostName = "algiers"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  # networking.nameservers = [ "1.1.1.1" "1.1.0.0" ];

  # Set your time zone.
  time.timeZone = "America/Chicago";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp1s0.useDHCP = true;

  environment.systemPackages = with pkgs; [
    pinentry-curses
  ];

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.05"; # Did you read the comment?

  boot.loader.grub.devices = [ "/dev/sda" ];

  # Initial empty root password for easy login:
  users.users.root.initialHashedPassword = "";
  services.openssh.settings.PermitRootLogin = "no";

  services.openssh.enable = true;

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGPUcN5An0gqAEH56hNzIMw8RmDGqSY/uGoenPskUHPM"
  ];

  systemd.services.nextcloud-previews = {
    enable = true;
    description = "Generate nextcloud previews";
    after = [ "docker.service" ];
    serviceConfig = {
      ExecStart = "/home/michael/pre_generate.sh";
    };
  };

  systemd.timers.nextcloud-previews = {
    enable = true;
    description = "Timer to generate nextcloud previews";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      Unit = "nextcloud-previews.service";
      OnCalendar = "daily";
      Persistent = true;
    };
  };

  fileSystems."/mnt/storagebox" = {
    device = "//sb1.mdonovan.dev/u354855-sub1";
    fsType = "cifs";
    options = [ "${smbOpts}" "iocharset=utf8" ];
  };

  virtualisation.docker = {
    enable = true;
    daemon.settings = {
      dns = [
        "1.1.1.1"
        "1.1.0.0"
      ];
    };
  };

}

