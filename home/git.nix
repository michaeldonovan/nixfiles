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
      key = "8F1CEA0A21036F44";
    };
    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = true;
    };
  };
}
