local utils = require("utils")

return {
  -- syntax highlight
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if opts.ensure_installed ~= "all" then
        opts.ensure_installed = utils.list_insert_unique(opts.ensure_installed, { "bash" })
      end
    end,
  },
  -- language server
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- install and config bashls
        bashls = {},
      },
    },
  },
  -- formatter & linter & code actions
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = utils.list_insert_unique(opts.ensure_installed, { "shfmt", "shellcheck" })
    end,
  },
  {
    "nvimtools/none-ls.nvim",
    -- optional = true,
    opts = function(_, opts)
      if type(opts.sources) == "table" then
        local nls = require("null-ls")
        vim.list_extend(opts.sources, {
          nls.builtins.formatting.shfmt,
          nls.builtins.diagnostics.shellcheck,
          nls.builtins.code_actions.shellcheck,
        })
      end
    end,
  },
}
