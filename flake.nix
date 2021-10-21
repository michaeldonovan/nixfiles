{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    utils.url = "github:gytis-ivaskevicius/flake-utils-plus";
    musnix.url = "github:musnix/musnix";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-darwin = {
      url = "github:LnL7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, utils, nur, home-manager, musnix, nix-darwin, ... }:
    utils.lib.mkFlake {
      inherit self inputs;


      sharedOverlays = [
        nur.overlay
      ];

      channelsConfig.allowUnfree = true;

      hosts = {
        monolith = {
          system = "x86_64-linux";
          modules = [
            ./hosts/monolith
            ./hosts/monolith/home

            ./modules/common.nix
            ./modules/yubikey.nix
            ./modules/wine.nix
            ./modules/samba.nix
            ./modules/monitor-brightness.nix
            ./modules/audio.nix
            ./modules/docker.nix
            ./modules/fonts.nix

            musnix.nixosModules.musnix
            home-manager.nixosModule

            ({ pkgs, ... }:
              let
                nur-no-pkgs = import nur {
                  nurpkgs = import nixpkgs { system = "x86_64-linux"; };
                };
              in
              {
                imports = [
                  nur-no-pkgs.repos.ilya-fedin.modules.flatpak-fonts
                  nur-no-pkgs.repos.ilya-fedin.modules.flatpak-icons
                ];
              })
          ];
        };

        MacBook = {
          system = "aarch64-darwin";
          output = "darwinConfigurations";
          builder = args: nix-darwin.lib.darwinSystem (removeAttrs args [ "system" ]);
          modules = [
            ./hosts/MacBook
            ./hosts/MacBook/home

            home-manager.darwinModule
          ];
        };

        nixos-template = {
          system = "x86_64-linux";
          modules = [
            ./hosts/nixos-template

            ./modules/common.nix
            ./modules/docker.nix
            ./modules/zabbix-agent.nix

            home-manager.nixosModule
          ];
        };
      };

      outputsBuilder = channels: with channels.nixpkgs;{
        devShell = mkShell {
          buildInputs = [ git nixpkgs-fmt lefthook ];
        };
      };
    };
}
