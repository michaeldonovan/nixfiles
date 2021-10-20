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
  };

  outputs = inputs@{ self, nixpkgs, utils, nur, home-manager, musnix, ... }:
    utils.lib.mkFlake {
      inherit self inputs;


      sharedOverlays = [
        nur.overlay
      ];

      channelsConfig.allowUnfree = true;

      hostDefaults = {
        system = "x86_64-linux";
        modules = [
          home-manager.nixosModule
          ./modules/common.nix
        ];
      };

      hosts = {
        monolith = {
          modules = [
            ./hosts/monolith
            ./hosts/monolith/home/home.nix
            ./modules/yubikey.nix
            ./modules/wine.nix
            ./modules/samba.nix
            ./modules/monitor-brightness.nix
            ./modules/audio.nix
            ./modules/docker.nix
            ./modules/fonts.nix
            musnix.nixosModules.musnix

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

        nixos-template = {
          modules = [
            ./hosts/nixos-template
            ./modules/docker.nix
            ./modules/zabbix-agent.nix
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
