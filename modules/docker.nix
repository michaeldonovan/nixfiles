{ config, pkgs, ... }:
{
  users.users.michael.extraGroups = [
    "docker"
  ];

  virtualisation.docker = {
    enable = true;
    autoPrune = {
      enable = true;
    };
    daemon.settings = {
      registry-mirrors = [
        "https://cr.mdonovan.org"
      ];
    };
  };



  environment.systemPackages = with pkgs; [
    docker
    docker-compose
    nix-prefetch-docker
    ctop
  ];
}
