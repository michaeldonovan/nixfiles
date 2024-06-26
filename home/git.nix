{ config, pkgs, ... }:
{
  programs.git = {
    enable = true;
    userName = "Michael Donovan";
    userEmail = "michael@mdonovan.dev";
    delta.enable = true;
    ignores = [ "*~" "*.swp" ".nvimlog" ".DS_Store" ];
    signing = {
      signByDefault = true;
      key = "0xA63B40E64ED28BBF";
    };
    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = true;
      rebase.autoStash = true;
    };
    lfs.enable = true;
  };
}
