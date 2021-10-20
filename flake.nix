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

      supportedSystems = [ "x86_64-linux" "aarch64-darwin" ];

      sharedOverlays = [
        self.overlay
        inputs.nur.overlay
      ];

      channelsConfig.allowUnfree = true;

      hosts = {
        monolith.modules = [
          ./hosts/monolith/configuration.nix
          ./hosts/monolith/home/home.nix
          home-manager.nixosModule
        ];

        MacBook-Air.modules = [
          ./hosts/MacBook-Air/home/home.nix
          home-manager.darwinModule
        ];
      };

      outputsBuilder = channels: with channels.nixpkgs;{
        devShell = mkShell {
          buildInputs = [ git nixpkgs-fmt lefthook ];
        };
      };
    };
}