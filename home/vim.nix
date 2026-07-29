{ pkgs, ... }:
{
  programs.nvchad = {
    enable = true;
    extraPackages = with pkgs; [
      nixd
      nixfmt
      vscode-json-languageserver
    ];
    extraConfig = ''
            vim.filetype.add({
              extension = {
                jsonc = "jsonc",
              },
            })
      u
            vim.api.nvim_create_autocmd("FileType", {
              pattern = "jsonc",
              callback = function()
                vim.bo.commentstring = "// %s"
              end,
            })

            local nixd_config = {
              cmd = { "nixd" },
              filetypes = { "nix" },
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

            local jsonls_config = {
              cmd = { "vscode-json-languageserver", "--stdio" },
              filetypes = { "json", "jsonc" },
              settings = {
                json = {
                  validate = { enable = true },
                },
              },
            }

            local jsonls_root_dir = function(first, second)
              if type(second) == "function" then
                second(vim.fs.dirname(vim.api.nvim_buf_get_name(first)))
              else
                return vim.fn.fnamemodify(first, ":h")
              end
            end
            jsonls_config.root_dir = jsonls_root_dir

            if vim.lsp and vim.lsp.config then
              vim.lsp.config("nixd", nixd_config)
              vim.lsp.enable("nixd")

              vim.lsp.config("jsonls", jsonls_config)
              vim.lsp.enable("jsonls")
            else
              local ok, lspconfig = pcall(require, "lspconfig")
              if ok then
                lspconfig.nixd.setup(nixd_config)
                lspconfig.jsonls.setup(jsonls_config)
              end
            end
    '';
  };

  home.sessionVariables = {
    EDITOR = "nvim";
  };
}
