return {
  "jose-elias-alvarez/null-ls.nvim",
  event = { "BufReadPre", "BufNewFile" },
  keys = {
    { "<leader>n", desc = "Null-ls" },
    { "<leader>ni", ":NullLsInfo<cr>", desc = "Null-ls info" },
    { "<leader>nI", ":NullLsInstall<cr>", desc = "Null-ls install" },
    { "<leader>nl", ":NullLsLog<cr>", desc = "Null-ls log" },
    { "<leader>nu", ":NullLsUninstall<cr>", desc = "Null-ls uninstall" },
  },
  config = function()
    local null_ls = require("null-ls")
    local null_ls_utils = require("null-ls.utils")

    local formatting = null_ls.builtins.formatting -- to setup formatters
    local diagnostics = null_ls.builtins.diagnostics -- to setup linters
    local code_actions = null_ls.builtins.code_actions

    local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

    --------------------------------------------------------------------
    -- Configure formatters & linters via null-ls formatters
    --------------------------------------------------------------------

    null_ls.setup({
      -- add package.json as identifier for root (for typescript monorepos)
      root_dir = null_ls_utils.root_pattern(".null-ls-root", "Makefile", ".git", "package.json"),
      -- setup formatters & linters
      sources = {
        formatting.shfmt, -- shell formatter
        diagnostics.shellcheck, -- shell linter
        code_actions.shellcheck, -- shell code actions
        formatting.clang_format, -- c/cpp formatter
        diagnostics.hadolint, -- docker linter
        formatting.gofumpt, -- go formatter
        formatting.goimports, -- go formatter
        code_actions.gomodifytags, -- go code actions
        code_actions.impl, -- go code actions
        formatting.stylua, -- lua formatter
        formatting.prettierd.with({ -- js/ts formatter
          condition = function(utils)
            return utils.root_has_file({ ".prettierrc", ".prettierrc.js", ".prettierrc.json" })
          end,
          extra_filetypes = { "svelte" },
        }),
        diagnostics.eslint_d.with({ -- js/ts linter
          condition = function(utils)
            return utils.root_has_file({ ".eslintrc.js", ".eslintrc.json" }) -- only enable if root has .eslintrc.js or .eslintrc.cjs
          end,
        }),
        code_actions.eslint_d.with({ -- js/ts code actions
          condition = function(utils)
            return utils.root_has_file({ ".eslintrc.js", ".eslintrc.json" }) -- only enable if root has .eslintrc.js or .eslintrc.cjs
          end,
        }),
        formatting.black, -- python formatter
        formatting.isort, -- python formatter
        diagnostics.markdownlint, -- markdown linter
      },
      -- configure format on save
      on_attach = function(current_client, bufnr)
        if current_client.supports_method("textDocument/formatting") then
          vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
          vim.api.nvim_create_autocmd("BufWritePre", {
            group = augroup,
            buffer = bufnr,
            callback = function()
              vim.lsp.buf.format({
                filter = function(client)
                  --  only use null-ls for formatting instead of lsp server
                  return client.name == "null-ls"
                end,
                bufnr = bufnr,
              })
            end,
          })
        end
      end,
    })
  end,
}
