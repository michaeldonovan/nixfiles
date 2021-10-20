# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let
  hostname = "monolith";
  modulesDir = "../../modules";
in
{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./disks.nix
      ./gnome.nix
      ./borg.nix
      ./networking.nix
      ./virtualization.nix
      ../../modules/common.nix
      ../../modules/yubikey.nix
      ../../modules/wine.nix
      ../../modules/samba.nix
      ../../modules/monitor-brightness.nix
      ../../modules/audio.nix
      ../../modules/docker.nix
      ../../modules/fonts.nix
      ../../modules/flakesupport.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      grub.useOSProber = true;
    };
  };

  networking.hostName = "${hostname}"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # security
  # security.pam.u2f = {
  #   enable = true;
  #   authFile = "/etc/Yubico/u2f_keys";
  #   cue = true;
  #   control = "sufficient";
  # };

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  # };


  # Enable the X11 windowing system.
  services = {
    printing.enable = true;
    gvfs.enable = true;
    openssh.enable = true;
    fstrim.enable = true;
    smartd.enable = true;
    flatpak.enable = true;

    xserver = {
      enable = true;

      # Enable the GNOME Desktop Environment.
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;

      # amdgpu
      videoDrivers = [ "amdgpu" ];

      layout = "us";
    };

    zabbixAgent = {
      enable = true;
      server = "zabbix.localdomain";
      settings = {
        Hostname = "${config.networking.hostName}";
        ServerActive = "zabbix.localdomain";
      };
    };

    pcscd = {
      enable = true;
    };
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    htop
    python
    terminator
    samba
    smbclient
    pciutils
    xclip
    solaar
    swtpm
    radeontop
    cmake
  ];
  environment.gnome.excludePackages = with pkgs; [
    gnome.gnome-terminal
    gnome.gnome_terminal
    gnome.gnome-software
  ];


  programs.dconf.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.05"; # Did you read the comment?

  #env
  environment.etc = {
    "ansible/hosts".source = ../../../playbooks/hosts;
  };

  # hardware overrides
  hardware.logitech.wireless.enable = true;
  hardware.logitech.wireless.enableGraphical = true; # for solaar to be included

}

