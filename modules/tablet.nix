{ config, pkgs, ... }:
{
  hardware.opentabletdriver = {
    enable = true;
    daemon.enable = true;
  };
}
