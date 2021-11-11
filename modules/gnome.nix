{ config, pkgs, ... }:

{
  services.xserver.desktopManager = {
    gnome.enable = true;
    plasma5.enable = false;
  };

  environment.systemPackages = with pkgs; [
    gnomeExtensions.remmina-search-provider
    gnomeExtensions.dash-to-panel
    gnomeExtensions.dash-to-dock
    gnomeExtensions.tray-icons-reloaded
    gnomeExtensions.dynamic-panel-transparency
    gnomeExtensions.freon
    gnomeExtensions.blur-me
    gnomeExtensions.media-controls
    gnomeExtensions.move-clock
    gnomeExtensions.audio-switcher-40
    gnomeExtensions.tweaks-in-system-menu
    gnomeExtensions.weather-in-the-clock
    gnomeExtensions.air-quality
    gnomeExtensions.hide-universal-access
    gnomeExtensions.hide-activities-button
    gnomeExtensions.always-indicator
    gnomeExtensions.workspaces-bar
    gnomeExtensions.just-perfection
    gnomeExtensions.arc-menu


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