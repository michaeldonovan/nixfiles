{ config, pkgs, ... }:

{
  services.xserver.desktopManager = {
    gnome.enable = true;
    plasma5.enable = false;
  };

  environment.systemPackages = with pkgs; [
    gnomeExtensions.dash-to-dock
    gnomeExtensions.tray-icons-reloaded
    gnomeExtensions.dynamic-panel-transparency
    gnomeExtensions.freon
    gnomeExtensions.blur-me
    gnomeExtensions.media-controls
    gnomeExtensions.audio-switcher-40
    gnomeExtensions.tweaks-in-system-menu
    gnomeExtensions.weather-in-the-clock
    gnomeExtensions.hide-universal-access
    gnomeExtensions.hide-activities-button
    gnomeExtensions.always-indicator
    gnomeExtensions.just-perfection
    gnomeExtensions.arc-menu
    gnomeExtensions.timepp

    gnome.gnome-applets
    gnome.gnome-shell-extensions
    gnome.gnome-tweaks
  ];

  environment.gnome.excludePackages = with pkgs; [
    gnome.gnome-terminal
    gnome.gnome_terminal
    gnome.gnome-software
  ];
}
