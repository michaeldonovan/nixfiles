switch:
  sudo nixos-rebuild switch --flake . -j 8

up: 
  nix flake update --commit-lock-file

gc: 
  sudo nix-collect-garbage -d
  nix-collect-garbage -d


