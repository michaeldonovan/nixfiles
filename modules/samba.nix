{ lib, ... }:

let
  # this line prevents hanging on network split
  opts = "uid=nobody,gid=users,noperm,credentials=/etc/nixos/smb-secrets,x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";
in
{
  fileSystems."/mnt/reliant/Backups" = {
    device = "//reliant.localdomain/Backups";
    fsType = "cifs";
    options = [ "${opts}" ];
  };
  fileSystems."/mnt/reliant/Pictures" = {
    device = "//reliant.localdomain/Pictures";
    fsType = "cifs";
    options = [ "${opts}" ];
  };
  fileSystems."/mnt/reliant/Documents" = {
    device = "//reliant.localdomain/Documents";
    fsType = "cifs";
    options = [ "${opts}" ];
  };
  fileSystems."/mnt/reliant/Plex" = {
    device = "//reliant.localdomain/Plex";
    fsType = "cifs";
    options = [ "${opts}" ];
  };
  fileSystems."/mnt/reliant/Music" = {
    device = "//reliant.localdomain/Music";
    fsType = "cifs";
    options = [ "${opts}" ];
  };
  fileSystems."/mnt/reliant/Books" = {
    device = "//reliant.localdomain/Books";
    fsType = "cifs";
    options = [ "${opts}" ];
  };
}
