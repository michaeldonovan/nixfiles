{ config, ... }:

let
  nfsOpts = "x-systemd.automount,x-systemd.idle-timeout=60,x-systemd.device-timeout=175,x-systemd.mount-timeout=5s,noauto,soft";
  smbCredentialsFile = "/secrets/smb-secrets";
  smbOpts = "uid=1000,gid=100,credentials=${smbCredentialsFile},${nfsOpts}";

in
{
  imports =
    [
      ./gpu.nix
      ./borg.nix
    ];

  boot.supportedFilesystems = [ "zfs" ];
  #  boot.kernelParams = [ "zfs.zfs_arc_max=4294967296" ];
  networking.hostId = "5595a05c";
  boot.zfs.extraPools = [ "rhea" ];
  services.zfs = {
    autoScrub.enable = true;
  };
  services.sanoid = {
    enable = true;
    datasets = {
      "rhea" = {
        autoprune = true;
        daily = 7;
        hourly = 0;
        monthly = 0;
        recursive = true;
      };
      "rhea/appdata" = {
        autoprune = true;
        daily = 3;
        hourly = 6;
        monthly = 0;
        recursive = true;
      };
    };
  };

  services.rpcbind.enable = true; # needed for NFS

  fileSystems."/rendon/Plex" = {
    device = "192.168.1.146:/mnt/rendon/Plex";
    fsType = "nfs4";
    options = [ "${nfsOpts}" ];
  };
  fileSystems."/rendon/Downloads" = {
    device = "192.168.1.146:/mnt/rendon/Downloads";
    fsType = "nfs4";
    options = [ "${nfsOpts}" ];
  };
  fileSystems."/rendon/Books" = {
    device = "192.168.1.146:/mnt/rendon/Books";
    fsType = "nfs4";
    options = [ "${nfsOpts}" ];
  };
  fileSystems."/rendon/Backups" = {
    device = "192.168.1.146:/mnt/rendon/Backups";
    fsType = "nfs4";
    options = [ "${nfsOpts}" ];
  };
  fileSystems."/rendon/borg" = {
    device = "192.168.1.146:/mnt/rendon/borg";
    fsType = "nfs4";
    options = [ "${nfsOpts}" ];
  };
  fileSystems."/rendon/borgsrv" = {
    device = "192.168.1.146:/mnt/rendon/borgsrv";
    fsType = "nfs4";
    options = [ "${nfsOpts}" ];
  };
  /*
    fileSystems."/rendon/borg" = {
    device = "//192.168.1.146/borg";
    fsType = "cifs";
    options = [ "${smbOpts}" ];
    };
  */
  fileSystems."/rendon/Pictures" = {
    device = "192.168.1.146:/mnt/rendon/Pictures";
    fsType = "nfs4";
    options = [ "${nfsOpts}" ];
  };
  fileSystems."/rendon/Music" = {
    device = "192.168.1.146:/mnt/rendon/Music";
    fsType = "nfs4";
    options = [ "${nfsOpts}" "ro" ];
  };
  fileSystems."/rendon/Documents" = {
    device = "192.168.1.146:/mnt/rendon/Documents";
    fsType = "nfs4";
    options = [ "${nfsOpts}" "ro" ];
  };
  fileSystems."/rendon/Datasets" = {
    device = "//192.168.1.146/Datasets";
    fsType = "cifs";
    options = [ "${smbOpts}" "ro" ];
  };
  fileSystems."/rendon/proxmox_config_backups" = {
    device = "192.168.1.146:/mnt/rendon/proxmox_config_backups";
    fsType = "nfs4";
    options = [ "${nfsOpts}" "ro" ];
  };


  systemd.services.pfsense-backup = {
    enable = true;
    description = "Backup pfSense config";
    serviceConfig = {
      ExecStart = "/home/michael/bin/pfsense_backup.sh";
      User = "michael";
    };
  };

  systemd.timers.pfsense-backup = {
    enable = true;
    description = "Timer to backup pfSense config";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      Unit = "pfsense-backup.service";
      OnCalendar = "daily";
      Persistent = true;
    };
  };

  systemd.services.gitea-archive = {
    enable = true;
    description = "Backup gitea";
    serviceConfig = {
      ExecStart = "/home/michael/bin/gitea-archive/gitea-archive.sh";
      User = "michael";
    };
  };

  systemd.timers.gitea-archive = {
    enable = true;
    description = "Timer to backup gitea";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      Unit = "gitea-archive.service";
      OnCalendar = "daily";
      Persistent = true;
    };
  };

  systemd.services.xdarr-watchdog = {
    enable = true;
    serviceConfig = {
      ExecStart = "/home/michael/bin/xdarr-watchdog.sh";
      User = "michael";
    };
  };

  systemd.timers.xdarr-watchdog = {
    enable = true;
    wantedBy = [ "timers.target" ];
    timerConfig = {
      Unit = "xdarr-watchdog.service";
      OnCalendar = "*:0/5";
      Persistent = true;
    };
  };

}
