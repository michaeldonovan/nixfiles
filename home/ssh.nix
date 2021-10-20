{ config, pkgs,  ... }:

{
    home.packages = with pkgs; [
        ssh-import-id
    ];

    home.file.".ssh/config".source = ../../../ssh/config;
}