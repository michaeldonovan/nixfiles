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
    speedtest-cli
    PyGithub
    tqdm
    pytheory
    jupyter
  ]);
in
{
  home.packages = with pkgs; [
    python-with-my-packages
  ];
}
