{ config, ... }:
let
  nfsOpts = "_netdev";
  smbCredentialsFile = "/secrets/smb-secrets";
  smbOpts = "uid=1000,gid=100,credentials=${smbCredentialsFile},${nfsOpts},mfsymlinks";
in
{
  imports =
    [
      ./gpu.nix
      ./borg.nix
    ];

  boot.loader.grub.device = "/dev/sda";
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

  virtualisation.docker.daemon.settings = {
    data-root = "/rhea/dockersys";
  };

  services.rpcbind.enable = true; # needed for NFS

  fileSystems."/rendon/Plex" = {
    device = "//192.168.1.146/Plex";
    fsType = "cifs";
    options = [ "${smbOpts}" ];
  };
  fileSystems."/rendon/Downloads" = {
    device = "192.168.1.146:/mnt/rendon/Downloads";
    fsType = "nfs4";
    options = [ "${nfsOpts}" ];
  };
  fileSystems."/rendon/Books" = {
    device = "//192.168.1.146/Books";
    fsType = "cifs";
    options = [ "${smbOpts}" ];
  };
  fileSystems."/rendon/Backups" = {
    device = "//192.168.1.146/Backups";
    fsType = "cifs";
    options = [ "${smbOpts}" ];
  };
  fileSystems."/rendon/borg" = {
    device = "192.168.1.146:/mnt/rendon/borg";
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
    device = "//192.168.1.146/Pictures";
    fsType = "cifs";
    options = [ "${smbOpts}" ];
  };
  fileSystems."/rendon/Music" = {
    device = "//192.168.1.146/Music";
    fsType = "cifs";
    options = [ "${smbOpts}" "ro" ];
  };
  fileSystems."/rendon/Documents" = {
    device = "//192.168.1.146/Documents";
    fsType = "cifs";
    options = [ "${smbOpts}" "ro" ];
  };
  fileSystems."/rendon/Datasets" = {
    device = "//192.168.1.146/Datasets";
    fsType = "cifs";
    options = [ "${smbOpts}" "ro" ];
  };
  fileSystems."/rendon/proxmox_config_backups" = {
    device = "//192.168.1.146/proxmox_config_backups";
    fsType = "cifs";
    options = [ "${smbOpts}" "ro" ];
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


  # photoprism backups
  systemd.services.photoprism-backup = {
    enable = true;
    serviceConfig = {
      ExecStart = "/run/current-system/sw/bin/docker compose -f /rhea/docker/photoprism/docker-compose.yml exec photoprism photoprism backup -i -f";
      User = "michael";
    };
  };

  systemd.timers.photoprism-backup = {
    enable = true;
    wantedBy = [ "timers.target" ];
    timerConfig = {
      Unit = "photoprism-backup.service";
      OnCalendar = "*-*-* 00:00:00";
      Persistent = true;
    };
  };

}
