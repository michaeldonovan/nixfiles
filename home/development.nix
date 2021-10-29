{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    cmake
    gnumake
    pkg-config
    gcc

    arduino
    ino

    gcc-arm-embedded
    dfu-util
    openocd

    boost175

    nodejs
    yarn
  ];
}