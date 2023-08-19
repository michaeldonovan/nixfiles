{ config, pkgs, lib, ... }:
{
  home.packages = with pkgs; [
    fish
    fishPlugins.foreign-env
  ];

  programs.fish = {
    enable = true;
    shellInit = ''
    '';

    interactiveShellInit = ''
      set -gx GPG_TTY (tty)
      
      if test -z "$TMUX"  && test -n "$SSH_CONNECTION" 
        tmux attach-session -t ssh_tmux || tmux new-session -s ssh_tmux
      end

      starship init fish | source

      set OP_PLUGINS_PATH $HOME/.config/op/plugins.sh
      if test -e $OP_PLUGINS_PATH
        source $OP_PLUGINS_PATH
      end

      if type -qf lvim
        abbr vim 'lvim'
      else if type -qf spacevim
        abbr vim 'spacevim'
      end

      fish_add_path $HOME/.local/bin
    '';

    shellAbbrs = {
      pull = "git pull";
      push = "git push";
      l = "ls -alskph";
      j = "z";
      ytdl = "youtube-dl -i -f \"bestvideo+bestaudio\"";
      gc = "sudo nix-collect-garbage --delete-older-than 7d";
      up-compose = "docker-compose up -d";
      down-compose = "docker-compose down";
      chat = "chatblade -i";
    };

    shellAliases = {
      git = "hub";
    };

    functions = {
      docker-update.body = ''
        docker run --rm -v /var/run/docker.sock:/var/run/docker.sock \
                           containrrr/watchtower \
                                              --run-once
                                              docker image prune -af
      '';
      fish_title.body = ''
        if [ $_ != "fish" ]
            echo $_
        else 
            prompt_pwd
        end
      '';
      nix-rebuild.body = ''
        if [ (uname) = "Darwin" ]
            pushd ~/nixfiles 
            darwin-rebuild --flake . -j (nproc) $argv
            pushd
        else 
            sudo nixos-rebuild switch --flake ~/nixfiles -j (nproc) 
        end
      '';

    };

    plugins = [
      {
        name = "bass";
        src = pkgs.fetchFromGitHub {
          owner = "edc";
          repo = "bass";
          rev = "f3a547b0239cf8529d35c1922dd242bacf751d3b";
          sha256 = "3mFlFiqGfQ+GfNshwKfhQ39AuNMdt8Nv2Vgb7bBV7L4=";
        };
      }
      {
        name = "github-copilot-cli";
        src = pkgs.fetchFromGitHub {
          owner = "z11i";
          repo = "github-copilot-cli.fish";
          rev = "ccb6367bbb3055ea19b9ff0eac1ccf1c5e86419a";
          sha256 = "cnmxvnG3WN2uqtt1aUEf0OFJulQSpFd3RJeeVKpDI9Y=";
        };
      }
      {
        name = "z";
        src = pkgs.fetchFromGitHub {
          owner = "jethrokuan";
          repo = "z";
          rev = "85f863f20f24faf675827fb00f3a4e15c7838d76";
          sha256 = "+FUBM7CodtZrYKqU542fQD+ZDGrd2438trKM0tIESs0=";
        };
      }
    ];
  };

  xdg.configFile."fish/conf.d/fish_user_key_bindings.fish".text = ''
    function fish_user_key_bindings
        fish_vi_key_bindings
    end
  '';
}
