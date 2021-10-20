
{ config, pkgs, ... }:

{
  users.users.michael.extraGroups = [ 
    "docker"
  ];

  virtualisation.docker.enable = true;

  environment.systemPackages = with pkgs; [
    docker
    docker-compose
    arion
    nix-prefetch-docker
    ctop

    gnomeExtensions.docker-integration
  ];
}