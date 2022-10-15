{ config, pkgs, ... }:

{
  home-manager = {
    useGlobalPkgs = true;
    users = {
      michael = {
        home.stateVersion = "21.11";
        imports = [
          ../../../home/cli.nix
        ];

        home.sessionVariables = {
          SSH_AUTH_SOCK = "/Users/michael/Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data/socket.ssh";
        };

        home.packages = with pkgs; [
          plantuml
          plantuml-server
        ];
      };
    };
  };
}
