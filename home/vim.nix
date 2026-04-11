{ pkgs, ... }:
{
  programs.nvchad = {
    enable = true;
    extraPackages = with pkgs; [
      nixd
      nixfmt-rfc-style
    ];
    extraConfig = ''
      local nixd_config = {
        cmd = { "nixd" },
        settings = {
          nixd = {
            nixpkgs = {
              expr = "import <nixpkgs> { }",
            },
            formatting = {
              command = { "nixfmt" },
            },
          },
        },
      }

      if vim.lsp and vim.lsp.config then
        vim.lsp.config("nixd", nixd_config)
        vim.lsp.enable("nixd")
      else
        local ok, lspconfig = pcall(require, "lspconfig")
        if ok then
          lspconfig.nixd.setup(nixd_config)
        end
      end
    '';
  };

  home.sessionVariables = {
    EDITOR = "nvim";
  };
}
