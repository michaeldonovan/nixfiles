{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    borgbackup
  ];
  services.borgmatic = {
    enable = true;
    settings = {
      location = {
        repositories = [
          "root@reliant.localdomain:/mnt/user/Backups/borg/{hostname}"
        ];
        source_directories = [
          "/home"
          "/etc"
        ];
        exclude_patterns = [
          "*cache*"
          "*Cache*"
          "*.tmp"
          "*.log"
          "/home/michael/.local/share/Steam"
          "/home/michael/Nextcloud/"
        ];
      };
      storage = {
        encryption_passcommand = "${pkgs.coreutils}/bin/cat /etc/borgmatic/key";
      };
      retention = {
        keep_daily = 7;
        keep_weekly = 4;
        keep_monthly = 6;
      };
      consistency = {
        checks = [
          "repository"
          "archives"
        ];
      };
      hooks = {
        healthchecks = "https://hc-ping.com/1caf2395-22ca-4d21-877c-c0838ef36234";
      };
    };
  };
  systemd.timers.borgmatictimer2 = {
    enable = true;
    description = "Timert to start borgmatic backup";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      Unit = "borgmatic.service";
      OnCalendar = "daily";
      Persistent = true;
      WakeSystem = true;
    };
  };

}
