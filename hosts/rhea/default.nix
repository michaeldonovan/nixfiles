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
  services.sanoid = {
    enable = true;
    datasets = {
      "rhea/appdata" = {
        autoprune = true;
        daily = 3;
        hourly = 6;
      };
    };
  };

  users.users.summit = {
    isNormalUser = true;
    extraGroups = [
    ];
    openssh.authorizedKeys.keys = [ "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC7wfXoUI/CLGC1v/6SN49b5wm+NzcKA9SFb/azJU6wELVeP99bZ+VCQZ2koUI9UJAkJ84a/R80G2fYJ9qYnLsiNi+n8Yib4FBQ+gGcsG6DdK4SidjH3aBFdxKOKFq7mHGyq6Tl0csB6prAiUcDEgsBkpmFjfD66LpZPXquQW90W3C0YTNZ/LdhYUYbOg+RS6cPlY7nPttNhoZCWDgw5G8K8/5HlHJtnSdCosJNcWfPYNrNHqMqq1ivaSIVBXU0cgzULZ0uWxT+Y5WHDrHRXa5WmzXo2xDPiT+fnaun2x0qeexah6KjFwbks1829WReTNtkqfeoQ/Fi3AFTl1kUlwh3Op1kuvEKvRoU9pH9GwNZhJGV3My5/yPRCNn3N9Fs7oXRLNfzhuS0dqpl3FTG9/sGV5gavCRUG0hezJNDuf+kGraUeIEDCysVLriSX0cWk3oPmj/Q0YMsbSQpHfIENKDxm8Mp8NNz39FlfFWxwVZxlpCKBpjigCdsFbgGs+X19/k=" ];
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
  fileSystems."/rendon/Documents" = {
    device = "192.168.1.146:/mnt/rendon/Documents";
    fsType = "nfs";
  };
  fileSystems."/rendon/Books" = {
    device = "192.168.1.146:/mnt/rendon/Books";
    fsType = "nfs";
  };
  fileSystems."/rendon/Backups" = {
    device = "192.168.1.146:/mnt/rendon/Backups";
    fsType = "nfs";
  };
  fileSystems."/rendon/borg" = {
    device = "192.168.1.146:/mnt/rendon/borg";
    fsType = "nfs";
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
      ExecStart = "/home/michael/bin/gitea-archive.sh";
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
}
