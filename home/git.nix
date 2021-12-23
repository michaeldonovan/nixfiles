{ config, pkgs, ... }:
{
  programs.git = {
    enable = true;
    userName = "Michael Donovan";
    userEmail = "michael@mdonovan.dev";
    delta.enable = true;
    ignores = [ "*~" "*.swp" ".nvimlog" ];
    signing = {
      signByDefault = true;
      key = "A63B40E64ED28BBF";
    };
    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = true;
    };
  };
}
