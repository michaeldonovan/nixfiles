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

      hostDefaults.system = "x86_64-linux";

      hosts = {
        monolith = {
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
            ./modules/tablet.nix

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
          builder = nix-darwin.lib.darwinSystem;
          modules = [
            ./hosts/MacBook
            ./hosts/MacBook/home

            ./modules/fonts.nix

            home-manager.darwinModule
          ];
        };

        proxmox-template = {
          extraArgs = {
            hostname = "proxmox-template";
            lanAddr = "192.168.1.150";
            vlanAddr = "192.168.2.150";
            extraPorts = [ ];
          };
          modules = [
            ./hosts/proxmox-template
            ./hosts/proxmox-template/home

            ./modules/common.nix
            ./modules/docker.nix
            ./modules/zabbix-agent.nix

            home-manager.nixosModule
          ];
        };

        orchid = {
          extraArgs = {
            hostname = "orchid";
            lanAddr = "192.168.1.158";
            vlanAddr = "192.168.2.158";
            extraPorts = [ 8581 ];
          };
          modules = [
            ./hosts/proxmox-template
            ./hosts/proxmox-template/home

            ./modules/common.nix
            ./modules/docker.nix
            ./modules/zabbix-agent.nix

            home-manager.nixosModule
          ];
        };

        zabbix = {
          extraArgs = {
            hostname = "zabbix";
            lanAddr = "192.168.1.159";
            vlanAddr = "192.168.2.159";
            extraPorts = [ ];
          };
          modules = [
            ./hosts/proxmox-template
            ./hosts/proxmox-template/home

            ./modules/common.nix
            ./modules/docker.nix

            home-manager.nixosModule
          ];
        };

        algiers = {
          modules = [
            ./hosts/algiers
            ./hosts/algiers/home

            ./modules/common.nix
            ./modules/docker.nix

            home-manager.nixosModule
          ];
        };
      };

      outputsBuilder = channels: with channels.nixpkgs;{
        devShell = mkShell {
          buildInputs = [ git vim wget nixpkgs-fmt ];
        };
      };
    };
}
