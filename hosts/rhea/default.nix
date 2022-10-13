{ config, ... }:
{
  imports =
    [
    ];

    boot.supportedFilesystems = [ "zfs" ];
    boot.kernelParams = [ "zfs.zfs_arc_max=512000000" ];
    networking.hostId = "5595a05c";
    boot.zfs.extraPools = [ "rhea" ];
    services.zfs = {
      autoScrub.enable = true;
    };

  services.rpcbind.enable = true; # needed for NFS

  fileSystems."/rendon/Plex" = {
    device = "192.168.1.146:/mnt/rendon/Plex";
    fsType = "nfs";
  };
  fileSystems."/rendon/Downloads" = {
    device = "192.168.1.146:/mnt/rendon/Downloads";
    fsType = "nfs";
  };
  fileSystems."/rendon/Books" = {
    device = "192.168.1.146:/mnt/rendon/Books";
    fsType = "nfs";
  };
}
