{ config, pkgs, ... }:
{
  programs.tmux = {
    enable = true;
    sensibleOnTop = true;
    plugins = with pkgs.tmuxPlugins; [
      sensible
      yank
      cpu
      {
        plugin = resurrect;
        extraConfig = "set -g @resurrect-strategy-nvim 'session'";
      }
      {
        plugin = continuum;
        extraConfig = ''
          set -g @continuum-restore 'on'
          set -g @continuum-save-interval '60' # minutes
        '';
      }
      /*
      {
        plugin = dracula;
        extraConfig = ''
          set -g @dracula-plugins "cpu-usage ram-usage time"
          set -g @dracula-show-battery false
          set -g @dracula-refresh-rate 10
          set -g @dracula-show-left-icon session 
        '';
      }*/

    ];
    # read tmux config from .tmux.conf
    extraConfig = builtins.readFile ./.tmux.conf;
  };
}
