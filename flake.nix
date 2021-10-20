{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    utils.url = "github:gytis-ivaskevicius/flake-utils-plus";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, utils, nur, home-manager, ... }:
    utils.lib.mkFlake {
      inherit self inputs;


      sharedOverlays = [
        inputs.nur.overlay
      ];

      channelsConfig.allowUnfree = true;

      hostDefaults.system = "x86_64-linux";

      hosts = {
        monolith = {
          modules = [
            ./hosts/monolith/configuration.nix
            ./hosts/monolith/home/home.nix
            home-manager.nixosModule
          ];
        };

        MacBook-Air = {
          system = "aarch64-darwin";
          output = "darwinConfigurations";
          #builder = args: nix-darwin.lib.darwinSystem (removeAttrs args [ "system" ]);
          modules = [
            ./hosts/MacBook-Air/home/home.nix
            home-manager.darwinModule
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
