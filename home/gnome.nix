{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    gnomeExtensions.remmina-search-provider
    gnomeExtensions.dash-to-panel
    gnomeExtensions.dash-to-dock
    gnomeExtensions.tray-icons-reloaded
    gnomeExtensions.dynamic-panel-transparency
    gnomeExtensions.top-panel-notification-icons
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
    gnomeExtensions.transparent-shell

    gnome.gnome-applets
    gnome.gnome-shell-extensions
    gnome.gnome-tweaks
  ];

}
