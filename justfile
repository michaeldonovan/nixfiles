switch:
  #!/usr/bin/env bash
  if [[ $(uname) == Darwin ]]; then
    sudo darwin-rebuild switch --flake .
  else
    sudo nixos-rebuild switch --flake .
  fi

up: 
  nix flake update --commit-lock-file

gc: 
  sudo nix-collect-garbage -d
  nix-collect-garbage -d


