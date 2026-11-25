{
  config,
  pkgs,
  lib,
  ...
}:
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
    "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBFAGvLwIvzwWo48sYl8QBLmPxfabxK3JK9gZMfNMIE68iyw0eAXjiiuoH7/A6pq3jrh/PXmlxwwwhUtGDmASACE="
    "ssh-mldsa44-ed25519 AAAAE3NzaC1tbGRzYTQ0LWVkMjU1MTkAAAVAYNyj6q3bodabqQl8KHHIO0d4QLZCPug3hMHza/VU7ddtxon68FQB6VtyvNvXr3x6moJA8wCKTtDB8gg1Y1BJrrgEKPGLFkWr+cX7Ta93RB8sqTgVHrsH0zeX8FyL8zIgFnjtPV+vmJjoG8pg5maXdtW8/tidWj/fb10Nob3TJ40fjyCscc6/Xq4WbYVZS0225+OH2yZqmzeuVmVb0qFXXxwNWjvkKt5Tc7gAW8hxLeI5b2QzhzMQLrrwtsgW7n6kut+WTAN977dC0RkKWtHyhGPROw124XK2Q3lbMFcfsskiZEFMflzzmY0CDAjSIG7JSTsreohd73iH+dvoQIZN9pWP+1QtHqgPuA88vcxv9hWGFJ84j/qDq48xZBAjPDHT0Ij9Sun/VloIeG4dfmhRQBa2pvEhVSYQfO/y630kCp1WiPb/pfTjGKWohzeapl+KQCbFNe3H55+MAOEtIDQRt1t8KE4RGen3g6EgqDNdBDPTPZU9yhtqA5o5EcnjDHsi5RWpzEQi7CRCuKbwY1iJ1LBpRG3hmndoNEj0utfH/IJMD8aer2UShjWFDwBFecMJ735jJtJ0kuvVkV43YsqyyGd19oUT3ehiVQ3sItkfvJ7Wp6iNvfvuSMZ0y00S41DXyAx45T8CGeejyFSLRX8cWgsTDTyFrKCkdwW1rce2saas+s9IKZBy3+/fA2GumFA+/Y4sG0Iyzwg07d6VE/yEOo58wFdMxhuIG4apq+9W90+fd/ZjTvELIqqMBTD7sDndtuywlrQ3OzZOXlu6+rJYosm6//Jw63Pjd0OCpJqCE24K2Sy0ZpbVFSv/hHbCJ8l2Mzl/lSH3BqPVtukAjVM1mdmgxrGWAOyXV3782jexT9Q3bsCsdWYa76ZtLRyWf1lIgeP9tQaspemEmTdedEn3g7ZmmFhn4WD09q4uQe9UpaSH9TlSN+FQErOHpKlxB1FRUUhmceHDmT8WQgabKvr6oBraqT+WLKxTh37KHwcHIRYaGCeyu5LPmQWroOHBPa0RlCag89Jwfn1tD5YxD6MLhjjf4yJQfbwhoK7oqREzYwGVhUfZzpk62ujx14+o6Q/3sR53upzyNC22hdSO9zhRovEsstCi9UefCQTiRheegGBuTSdJoGGPOEFaw/RU9wUnlHNejGGEMyYG1AxttIFSbtdXdqnGnO44WFgBVk+CLQMsD0L71osQrJDiBNWnaGzU8jIuTBIvCGvwQ0nF2IFQZvO3xfg0r/y+dsV5pnJmDGLhbItIjWycY2dPAxiVAj/gneMiMULfZzRBFkpOWGSXSSlEMq2dtuU7S232t7/xsnQuOlehX/nFh1n6J7roGW0F0KUVkvmmupjzcG/j0owB2iFcVxkcli4fhl/s1nddTDtxHNp/mvFpiEvtficSBMLC7NegdzHjvoqX1gAhHXwlEHLH9i7NnT1p+8pfaCENGDFiPq50D5DgmLJWNR3xZ6tK+7JAPpxYvOjKJGc1gspvPdwZOD4Bez2YQ2O79dD0vHRV5mKvZaSFtAxhA6eJIPPSoDluCkMyZNa9o6Ft0Fofz5UFX9yCj59YQ8DvVbykODr5cJ99TC6PsYIkRurfkQCW5VXK17xIoFowdBD7YAtqQ0073fsdE8WTkCBi9JoKGFhOSZBkeqSPUDh2SPEjq1NpDsOMu6DxvMyx5/LawgVpY4cuyBi6sTT9P3kfxBN2Ty1U9Kk/2RqFrei9FHTz15/DzD5wleGnim1xGODOvDCjlCP72Zu+7lgvyQGndxc0gIaJCL3BR0jwWoH6gs4fktUr michael@MacBook"
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

  users.users.n8n = {
    isNormalUser = true;
    home = "/home/n8n";
    extraGroups = [
      "docker"
    ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPs/pCiwaWX3pUG8kStQycqzz4mtGgQI0fNTyiOi4AY3"

    ];
  };

  environment.homeBinInPath = true;
}
