{ config, pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    fish
    fishPlugins.foreign-env
  ];

  programs.fish = {
    enable = true;
    shellInit = ''
      set -g simple_ass_prompt_greeting . 
      if [ $TERM = "xterm-kitty" ]
          alias ssh="kitty +kitten ssh"
      end
    '';

    interactiveShellInit = ''
      set -gx GPG_TTY (tty)
      
      if test -z "$TMUX"  && test -n "$SSH_CONNECTION" 
        tmux attach-session -t ssh_tmux || tmux new-session -s ssh_tmux
      end
    '';

    shellAbbrs = {
      pull = "git pull";
      push = "git push";
      l = "ls -alskph";
      j = "fasd_cd -d";
      vim = "spacevim";
      ytdl = "youtube-dl -i -f \"bestvideo+bestaudio\"";
      gc = "sudo nix-collect-garbage --delete-older-than 7d";
      up-compose = "docker-compose up -d";
      down-compose = "docker-compose down";
    };

    shellAliases = {
      git = "hub";
    };

    plugins = [
      # {
      #     name = "fasd";
      #     src = pkgs.fetchFromGitHub {
      #         owner = "oh-my-fish";
      #         repo = "plugin-fasd";
      #         rev = "98c4c729780d8bd0a86031db7d51a97d55025cf5";
      #         sha256 = "0m0q0x66b498lxmma9l9qxpzfkms4g7mg26xb6kh2p55vil1547h";
      #     };
      # }
      # {
      #     name = "vi-mode";
      #     src = pkgs.fetchFromGitHub {
      #         owner = "oh-my-fish";
      #         repo = "plugin-vi-mode";
      #         rev = "2655a7253077faefd2f0a57b799dee687344d4fb";
      #         sha256 = "1ww4z8ahx8ag38vbfccrfd9chv1gkg35fvwnnxwybyak6mnic5li";
      #     };
      # }
      # {
      #     name = "simple-ass-prompt";
      #     src = pkgs.fetchFromGitHub {
      #         owner = "lfiolhais";
      #         repo = "theme-simple-ass-prompt";
      #         rev = "b2d3ed234a0f9528369f5dc6452e2b1c6ca1b23e";
      #         sha256 = "1shasf1bx5zw99qccqpxpvl29h1jczhx33hi6fahjwp01x1d81cl";
      #     };
      # }
      # {
      #     name = "foreign-env";
      #     src = pkgs.fetchFromGitHub {
      #         owner = "oh-my-fish";
      #         repo = "plugin-foreign-env";
      #         rev = "dddd9213272a0ab848d474d0cbde12ad034e65bc";
      #         sha256 = "00xqlyl3lffc5l0viin1nyp819wf81fncqyz87jx8ljjdhilmgbs";
      #     };
      # }
    ];
  };

  xdg.configFile."fish/conf.d/fish_user_key_bindings.fish".text = ''
    function fish_user_key_bindings
        fish_vi_key_bindings
    end
  '';

  xdg.configFile."fish/functions/fish_title.fish".text = ''
    function fish_title 
        if [ $_ != "fish" ]
            echo $_
        else 
            prompt_pwd
        end
    end
  '';

  xdg.configFile."fish/functions/nix-rebuild.fish".text = ''
    function nix-rebuild
        if [ (uname) = "Darwin" ]
            pushd ~/nixfiles 
            darwin-rebuild --flake . -j (nproc) $argv
            pushd
        else 
            sudo nixos-rebuild -j (nproc) $argv
        end
    end
  '';
}
