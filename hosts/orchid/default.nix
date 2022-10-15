{ config, ... }:
{
  imports =
    [
    ];
  services.rpcbind.enable = true; # needed for NFS

  fileSystems."/rendon/orchidbackups" = {
    device = "192.168.1.146:/mnt/rendon/orchidbackups";
    fsType = "nfs";
    options = [ "user" ];
  };
}
