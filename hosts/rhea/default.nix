{ config, ... }:
let
  # this line prevents hanging on network split
  credentialsFile = "/secrets/smb-secrets";
  opts = "uid=nobody,gid=users,noperm,credentials=${credentialsFile},x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";
in
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

  /*
  fileSystems."/rendon/Plex" = {
    device = "192.168.1.146:/mnt/rendon/Plex";
    fsType = "smb";
    fsType = "nfs";
  };
  fileSystems."/rendon/Downloads" = {
    device = "192.168.1.146:/mnt/rendon/Downloads";
    fsType = "nfs";
  };
  */

  fileSystems."/rendon/Downloads" = {
    device = "//192.168.1.156/Downloads";
    fsType = "cifs";
    options = [ "${opts}" ];
  };
  fileSystems."/rendon/Plex" = {
    device = "//192.168.1.156/Plex";
    fsType = "cifs";
    options = [ "${opts}" ];
  };
}
