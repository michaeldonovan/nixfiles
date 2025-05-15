{ config, pkgs, ... }:
{
  programs.git = {
    enable = true;
    userName = "Michael Donovan";
    userEmail = "michael@mdonovan.dev";
    difftastic.enable = true;
    ignores = [ "*~" "*.swp" ".nvimlog" ".DS_Store" ];
    signing = {
      signByDefault = true;
      key = "0xA63B40E64ED28BBF";
    };
    aliases = {
      co = "checkout";
      cob = "checkout -b";
      br = "branch";
      ca = "commit -am";
      cm = "commit -m";
      st = "status";
      d = "diff";
      g = "log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)' --all";
      please = "push --force-with-lease";
      root = "rev-parse --show-toplevel";
    };
    extraConfig = {
      init.defaultBranch = "main";
      clone.recurseSubmodules = true;
      fetch.recurseSubmodules = true;
      pull = {
        rebase = true;
        recurseSubmodules = true;
      };
      push.autoSetupRemote = true;
      rebase.autoStash = true;
      blame.ignoreRefsFile = ".git-blame-ignore-revs";

    };
    lfs.enable = true;
  };
}
