{ pkgs, ... }:
{
  home.packages = with pkgs; [
    spacevim
  ];
  programs.neovim = {
    enable = true;
    vimAlias = true;
    withPython3 = true;
  };

  home.sessionVariables = {
    EDITOR = "${pkgs.spacevim}/bin/spacevim";
  };

  home.file.".SpaceVim.d/init.toml".text = ''
    [options]
        relativenumber = false
        default_indent = 4
        expand_tab = true
        colorscheme='hybrid'
        terminal_cursor_shape=2
        bootstrap_before = 'myspacevim#before'
        bootstrap_after = 'myspacevim#after'

    [[layers]]
        name = "lang#sh"
    [[layers]]
        name = "lang#python"
    [[layers]]
        name = "lang#toml"
    [[layers]]
        name = "lang#vim"
    [[layers]]
        name = "lang#nix"
    [[layers]]
        name = "lang#nix"
    [[layers]]
        name = "lang#fish"
    [[layers]]
        name = "lang#plantuml"
    [[layers]]
        name = "lang#c"
    [[layers]]
        name = "VersionControl"
    [[layers]]
        name = "checkers"
    [[layers]]
        name = "autocomplete"
    [[layers]]
        name = "ui"
    [[layers]]
        name = "git"
    [[layers]]
        name = "VersionControl"
  '';

  home.file.".SpaceVim.d/autoload/myspacevim.vim".text = ''
    function! myspacevim#before() abort
        map <C-N> :VimFiler<CR>
        inoremap lkj <Esc>:wq<CR>
        set listchars=tab:>-
        set list
    endfunction

    function! myspacevim#after() abort
    endfunction
  '';
}
