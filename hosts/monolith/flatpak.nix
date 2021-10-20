{ config, pkgs, lib, ... }:
let
  nur-no-pkgs = import
    (builtins.fetchTarball {
      url = "https://github.com/nix-community/NUR/archive/9b659bd5e9320987f3ea09a195233dac47902878.tar.gz";
      sha256 = "0x3zy14yqcpwd58h8i304jyl60wnki1q7p5qs0bgkh149ddzk4p2";
    })
    { };
in
{
  imports = [
    nur-no-pkgs.repos.ilya-fedin.modules.flatpak-fonts
    nur-no-pkgs.repos.ilya-fedin.modules.flatpak-icons
  ];
}
