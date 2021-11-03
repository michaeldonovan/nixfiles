{ config, pkgs, ... }:

{
  home-manager = {
    useGlobalPkgs = true;
    users = {
      michael = {
        home.stateVersion = "21.11";
        imports = [
          ../../../home/cli-linux.nix
          ../../../home/docker.nix
          ../../../home/development.nix
        ];
      };
    };
  };
}
