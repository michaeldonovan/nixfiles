{ config, lib, pkgs, ... }:
let
in
{
  users.users.semaphore = {
    isNormalUser = true;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL9TESRl4k1xBA/vFQqtuMIShzK01C6m1zjC3s5y03D8"
    ];
    extraGroups = [
      "docker"
    ];
  };

  environment.systemPackages = with pkgs; [
    (python3.withPackages (p: with p; [
      requests
      xmltodict
    ]))
  ];

}
