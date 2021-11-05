{ config, pkgs, ... }:
with pkgs;
let
  python-with-my-packages = pkgs.python3.withPackages (p: with p; [
    pip
    ipython
  ]);
in
{
  home.packages = with pkgs; [
    python-with-my-packages
  ];
}
