{ cfg, pkgs, ... }:
{
  services.cron = {
    enable = true;
    systemCronJobs = [
      "0 1 * * * /home/michael/pre_generate.sh"
    ];
  };
}
