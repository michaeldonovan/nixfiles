{ config, ... }:
{
  imports =
    [
      ./wireguard.nix
    ];

  boot.loader.grub.device = "/dev/sda";
}
