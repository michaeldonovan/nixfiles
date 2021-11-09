{ config, pkgs, ... }:
with pkgs;
let
  python-with-my-packages = pkgs.python3.withPackages (p: with p; [
    pip
    ipython
    termcolor
    tabulate
    paramiko
    autopep8
  ]);
in
{
  home.packages = with pkgs; [
    python-with-my-packages
  ];
}
