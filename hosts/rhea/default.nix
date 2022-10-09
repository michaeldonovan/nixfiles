{ config, ... }:
{
  imports =
    [
    ];
  services.rpcbind.enable = true; # needed for NFS
  fileSystems."/rendon/Plex" = {
    device = "192.168.1.146:/mnt/rendon/Plex";
    fsType = "nfs";
  };
  fileSystems."/rendon/appdata" = {
    device = "192.168.1.146:/mnt/rendon/appdata";
    fsType = "nfs";
  };
  fileSystems."/rendon/Downloads" = {
    device = "192.168.1.146:/mnt/rendon/Downloads";
    fsType = "nfs";
  };
}
