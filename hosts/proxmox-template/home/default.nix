{ config, pkgs, ... }:

{
  home-manager = {
    useGlobalPkgs = true;
    users = {
      michael = {
        home.stateVersion = "21.11";
        imports = [
          ../../../home/cli-linux.nix
          ../../../home/python.nix
          ../../../home/docker.nix
        ];
      };
    };
  };
}
