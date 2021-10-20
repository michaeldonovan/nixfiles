{ config, lib, pkgs, ... }:

# igpu: 0000:00:02.0
{
  users.users.michael.extraGroups = [
    "libvirtd"
    "qemu-libvirtd"
  ];
  boot.kernel.sysctl = { "net.ipv4.ip_forward" = 1; };

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
      qemuOvmf = true;
      qemuRunAsRoot = true;

      onBoot = "ignore";
      onShutdown = "shutdown";
    };
  };

  # systemd.tmpfiles.rules = [
  #   "f /dev/shm/looking-glass 0660 michael qemu-libvirtd -"
  #   "f /dev/shm/scream 0660 michael qemu-libvirtd -"
  # ];

  # systemd.user.services.scream-ivshmem = {
  #   enable = true;
  #   description = "Scream IVSHMEM";
  #   serviceConfig = {
  #     ExecStart =
  #       "${pkgs.scream}/bin/scream -o pulse -m /dev/shm/scream";
  #     Restart = "always";
  #   };
  #   wantedBy = [ "multi-user.target" ];
  #   requires = [ "pipewire.service" ];
  # };

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
