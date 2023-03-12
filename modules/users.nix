{ config, pkgs, lib, ... }:
let
  ssh-keys = [
    "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBHqLljawKuGhWuLpiFTs3cFj6sezvD0rVymaQ631QFZ4jHiJ5pqqyegWUcjGstxMRRymgPu2+evM3sKCvDo6/eU="
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGPUcN5An0gqAEH56hNzIMw8RmDGqSY/uGoenPskUHPM"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC0ORCwUG71gRB3+qMx7ASej0px/aCdSnYUSs8EAIpne"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJIIfg16lNol+oHsSCwunDLSK4EY0IFXXBnoCXFUY2Ov"
    "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIG822TCsI9xe1AxoslofXMeBQnySxrn0xV9yHVAewtDVAAAABHNzaDo="
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILsIPaApMqFdnDO+w0dZ2GgY4tWjFQylCgV8Blg16p0V"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINfWz6xkiMY7jx9gfk+/SKqrB8RFt3OIix1n1wgzJEjX"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJyNWAIEFNPlW89cjyk43XQbNyk9RJNC0e5iTQF7M5/S"
  ];
in
{
  users.users.michael = {
    isNormalUser = true;
    home = "/home/michael";
    shell = pkgs.fish;
    useDefaultShell = false;
    extraGroups = [
      "wheel"
    ];
    openssh.authorizedKeys.keys = ssh-keys;
  };

  users.users.root = {
    shell = pkgs.fish;
    openssh.authorizedKeys.keys = ssh-keys;
  };

  environment.homeBinInPath = true;
}
