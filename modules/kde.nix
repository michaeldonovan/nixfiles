{ config, pkgs, ... }:
{
  services.xserver.displayManager.defaultSession = "plasmawayland";
  services.xserver.desktopManager = {
    gnome.enable = false;
    plasma5 = {
      enable = true;
      supportDDC = true;
      runUsingSystemd = true;
    };
  };
  environment.systemPackages = with pkgs; [
    adapta-kde
    }
