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
          "borgmatic@reliant.localdomain:/mnt/user/Backups/borg/{hostname}"
        ];
        source_directories = [
          "/home"
          "/etc"
          "/secrets"
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
        encryption_passcommand = "${pkgs.coreutils}/bin/cat /secrets/borgmatic_key";
        ssh_command = "${pkgs.openssh}/bin/ssh -i /home/michael/.ssh/id_ed25519";
        relocated_repo_access_is_ok = true;
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

  # Timer built into borgmatic package hasn't been working for me
  systemd.timers.borgmatic = {
    enable = true;
    description = "timer to start borgmatic backup";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      Unit = "borgmatic.service";
      OnCalendar = "daily";
      Persistent = true;
      WakeSystem = true;
    };
  };

}
