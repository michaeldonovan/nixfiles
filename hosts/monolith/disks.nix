{ lib, ... }:
{
  boot.supportedFilesystems = [ "ntfs" ];

  fileSystems."/mnt/media" = {
    device = "/dev/disk/by-id/ata-ADATA_SU800_2J4920174573-part1";
    fsType = "ntfs";
    options = [ "rw" "uid=1000" ];
  };
}
