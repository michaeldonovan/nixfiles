{ config, ... }:
let
  nfsOpts = "x-systemd.automount,x-systemd.idle-timeout=60,x-systemd.device-timeout=175,x-systemd.mount-timeout=5s,noauto,soft";
in
{
  imports =
    [
    ];

  boot.supportedFilesystems = [ "zfs" ];
  boot.kernelParams = [ "zfs.zfs_arc_max=4294967296" ];
  networking.hostId = "22c6e578";
  boot.zfs.extraPools = [ "orchid" ];
  services.zfs = {
    autoScrub.enable = true;
  };

  services.sanoid = {
    enable = true;
    datasets = {
      "orchid" = {
        autoprune = true;
        daily = 3;
        hourly = 24;
        recursive = true;
      };
    };
  };

  services.rpcbind.enable = true; # needed for NFS

  fileSystems."/rendon/orchidbackups" = {
    device = "192.168.1.146:/mnt/rendon/orchidbackups";
    fsType = "nfs";
    options = [ "${nfsOpts}" "user" ];
  };
  fileSystems."/rendon/Books" = {
    device = "192.168.1.146:/mnt/rendon/Books";
    fsType = "nfs";
    options = [ "${nfsOpts}" ];
  };
}
