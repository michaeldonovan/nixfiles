{ config, pkgs, ... }:
let
  overrideDir = "/var/lib/flatpak/overrides";
in
{
  services.flatpak.enable = true;
  environment.etc."flatpak_overrides/com.spotify.Client".text = ''
    [Environment]
    XCURSOR_THEME=Adwaita
  '';
  environment.etc."flatpak_overrides/org.telegram.desktop".text = ''
    [Environment]
    XCURSOR_THEME=Adwaita
  '';
  systemd.tmpfiles.rules = [
    "L+ /var/lib/flatpak/overrides - - - - /etc/flatpak_overrides"
  ];

}
