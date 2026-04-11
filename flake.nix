{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    utils.url = "github:gytis-ivaskevicius/flake-utils-plus";
    vscode-server = {
      url = "github:nix-community/nixos-vscode-server";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    claude-code = {
      url = "github:sadjow/claude-code-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix4nvchad = {
      url = "github:nix-community/nix4nvchad";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur = {
      url = "github:nix-community/NUR";
    };

    nix-darwin = {
      url = "github:LnL7/nix-darwin/nix-darwin-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{ self
    , nixpkgs
    , utils
    , nur
    , home-manager
    , nix-darwin
    , vscode-server
    , claude-code
    , nix4nvchad
    , ...
    }:
    let
      nvchadHmModule = {
        home-manager.sharedModules = [ nix4nvchad.homeManagerModule ];
      };
    in
    utils.lib.mkFlake {
      inherit self inputs;

      sharedOverlays = [
        nur.overlays.default
        (
          final: prev:
            if prev.stdenv.hostPlatform.isDarwin then
              {
                direnv = prev.direnv.overrideAttrs (old: {
                  postPatch = (old.postPatch or "") + ''
                    substituteInPlace GNUmakefile \
                      --replace "-linkmode=external" "-linkmode=internal"
                  '';
                });
              }
            else
              { }
        )
      ];

      channelsConfig.allowUnfree = true;

      hostDefaults.system = "x86_64-linux";

      hosts = {
        MacBook = {
          system = "aarch64-darwin";
          output = "darwinConfigurations";
          builder = nix-darwin.lib.darwinSystem;
          modules = [
            nvchadHmModule
            ./hosts/MacBook
            ./hosts/MacBook/home

            home-manager.darwinModules.home-manager
          ];
        };

        proxmox-template = {
          extraArgs = {
            hostname = "proxmox-template";
            netiface = "ens18";
            lanAddr = "192.168.1.150";
            vlanAddr = "192.168.2.150";
          };
          modules = [
            nvchadHmModule
            ./hosts/proxmox-template
            ./hosts/proxmox-template/home

            ./modules/common.nix
            ./modules/docker.nix
            ./modules/zabbix-agent.nix

            home-manager.nixosModules.home-manager
          ];
        };

        orchid = {
          extraArgs = {
            hostname = "orchid";
            netiface = "ens18";
            lanAddr = "192.168.1.158";
            vlanAddr = "192.168.2.158";
          };
          modules = [
            nvchadHmModule
            ./hosts/orchid
            ./hosts/proxmox-template
            ./hosts/proxmox-template/home

            ./modules/common.nix
            ./modules/docker.nix
            ./modules/zabbix-agent.nix
            ./modules/nofirewall.nix
            ./modules/summit-user.nix
            ./modules/semaphore.nix
            ./modules/vscode-server.nix

            vscode-server.nixosModules.default
            home-manager.nixosModules.home-manager
          ];
        };

        zabbix = {
          extraArgs = {
            hostname = "zabbix";
            netiface = "ens18";
            lanAddr = "192.168.1.159";
            vlanAddr = "192.168.2.159";
          };
          modules = [
            nvchadHmModule
            ./hosts/zabbix
            ./hosts/zabbix/home
            ./hosts/proxmox-template
            ./hosts/proxmox-template/home

            ./modules/common.nix
            ./modules/docker.nix
            ./modules/nofirewall.nix
            ./modules/semaphore.nix
            ./modules/vscode-server.nix

            vscode-server.nixosModules.default
            home-manager.nixosModules.home-manager
          ];
        };

        rhea = {
          extraArgs = {
            hostname = "rhea";
            netiface = "enp6s18";
            lanAddr = "192.168.1.142";
            vlanAddr = "192.168.2.142";
          };
          modules = [
            nvchadHmModule
            (
              { pkgs, ... }:
              {
                nixpkgs.overlays = [ claude-code.overlays.default ];
                environment.systemPackages = [ pkgs.claude-code ]; # or pkgs.claude-code-bun
              }
            )

            ./hosts/rhea
            ./hosts/proxmox-template
            ./hosts/proxmox-template/home

            ./modules/common.nix
            ./modules/docker.nix
            ./modules/zabbix-agent.nix
            ./modules/nofirewall.nix
            ./modules/summit-user.nix
            ./modules/semaphore.nix
            ./modules/vscode-server.nix

            vscode-server.nixosModules.default
            home-manager.nixosModules.home-manager
          ];
        };

        algiers = {
          modules = [
            nvchadHmModule
            ./hosts/algiers
            ./hosts/algiers/home

            ./modules/common.nix
            ./modules/docker.nix

            ./modules/semaphore.nix
            home-manager.nixosModules.home-manager
          ];
        };
      };

      outputsBuilder =
        channels: with channels.nixpkgs; {
          devShell = mkShell {
            buildInputs = [
              git
              vim
              wget
              nixpkgs-fmt
            ];
          };
        };
    };
}
