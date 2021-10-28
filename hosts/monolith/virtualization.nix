{ config, lib, pkgs, ... }:

# igpu: 0000:00:02.0
{
  users.users.michael.extraGroups = [
    "libvirtd"
    "qemu-libvirtd"
  ];
  boot.kernel.sysctl = { "net.ipv4.ip_forward" = 1; };
  boot.kernelParams = [ "intel_iommu=on" ];
  boot.kernelModules = [ "kvm-intel" "vfio_virqfd" "vfio_pci" "vfio_iommu_type1" "vfio" ];

  # passthrough windows boot drive, vega graphics, vega audio
  # boot.extraModprobeConfig = "options vfio-pci ids=126f:2262,1002:687f,1002:aaf8";

  environment.systemPackages = with pkgs; [
    libvirt
    virt-manager
    virt-viewer
    scream
    looking-glass-client
    gnomeExtensions.looking-glass-button
  ];

  virtualisation.kvmgt = {
    enable = true;
    vgpus = {
      "i915-GVTg_V5_8" = {
        uuid = [ "928f2ce6-2af8-11ec-b417-6b2f92106897" ];
      };
    };
  };

  # virtualisation
  virtualisation = {
    libvirtd = {
      enable = true;
      qemu.ovmf.enable = true;
      qemu.runAsRoot = true;

      onBoot = "ignore";
      onShutdown = "shutdown";
    };
  };

  systemd.tmpfiles.rules = [
    "f /dev/shm/looking-glass 0660 michael qemu-libvirtd -"
    # #   "f /dev/shm/scream 0660 michael qemu-libvirtd -"
  ];

  # systemd.services."usb-libvirt-hotplug@" = {
  #   enable = true;
  #   description = "Hotplug USB device for libvirt";
  #   after = [ "libvirtd.sevice" ];
  #   bindsTo = [ "dev-libvirt_%i.device" ];
  #   after = [ "dev-libvirt_%i.device" ];
  #   requisite = [ "dev-libvirt_%i.device" ];
  #   serviceConfig = {
  #     Type = "oneshot";
  #     RemainAfterExit = true;
  #     ExecStart =  "/home/michael/bin/usb-libvirt-hotplug-systemd.sh add %I";
  #     ExecStop =  "/home/michael/bin/usb-libvirt-hotplug-systemd.sh remove %I";
  #   };
  #   wantedBy = [ "dev-libvirt_%i.device" ];
  # }; 
}
