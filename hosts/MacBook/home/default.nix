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
          HOMEBREW_CLEANUP_MAX_AGE_DAYS = "0";
        };

        home.sessionPath = [
          "/opt/homebrew/bin"
          "/Users/michael/.local/bin"
          "/Users/michael/bin"
          "/Users/michael/.nix-profile/bin"
          "/run/current-system/sw/bin/nix"

        ];

        programs.zsh.enable = true;

        home.packages = with pkgs; [
          plantuml
          plantuml-server
        ];
      };
    };
  };
}
