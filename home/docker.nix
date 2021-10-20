{ config, pkgs, ... }:
{
  home.file."bin/docker-update"= {
    executable = true;
    text = ''
      #!/usr/bin/env bash
      docker run --rm -v /var/run/docker.sock:/var/run/docker.sock \
                         containrrr/watchtower \
                         --run-once
      docker image prune -af
    '';
  };
}
