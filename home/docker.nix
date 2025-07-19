{ config, pkgs, ... }:
{
  home.file."bin/docker-update" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash

      # Setup dockcheck if needed
      if [ ! -d "$HOME/bin/dockcheck" ]; then
          mkdir -p "$HOME/bin"
          git clone https://github.com/mag37/dockcheck "$HOME/bin/dockcheck"
      fi

      chmod +x "$HOME/bin/dockcheck/dockcheck.sh"

      # Check for active plex sessions
      exclude_plex=""
      if docker ps --format "{{.Names}}" | grep -q "^plex$"; then
          if [ -f "/secrets/plex-token" ]; then
              plex_token=$(cat /secrets/plex-token)
              sessions=$(curl -s -H "X-Plex-Token: $plex_token" "http://localhost:32400/status/sessions" 2>/dev/null)
              session_count=$(echo "$sessions" | grep -o 'size="[0-9]*"' | grep -o '[0-9]*' | head -1)
              
              if [ "$session_count" -gt 0 ] 2>/dev/null; then
                  echo -e "Found $session_count active plex sessions, excluding plex"
                  exclude_plex="-e plex"
              fi
          fi
      fi

      # Run dockcheck
      cmd="$HOME/bin/dockcheck/dockcheck.sh -aup $exclude_plex"
      echo
      echo "$cmd"
      eval $cmd
    '';
  };
}
