{ config, ... }:
{
  services.borgbackup.repos.deck = {
    path = "/rendon/borgsrv/deck";
    authorizedKeys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAgIijBx73/uttnNtga8nxKFaiO/eSeCL4sXPZJU8S54"
    ];
    quota = "30G";

  };
}
