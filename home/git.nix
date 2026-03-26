{ config, pkgs, ... }:
{
  programs.git = {
    enable = true;
    ignores = [ "*~" "*.swp" ".nvimlog" ".DS_Store" ".env" ".venv" ];
    signing = {
      signByDefault = true;
      key = "0xA63B40E64ED28BBF";
    };
    settings = {
      user = {
        name = "Michael Donovan";
        email = "michael@mdonovan.dev";
      };
      alias = {
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
  programs.difftastic.enable = true;
}
