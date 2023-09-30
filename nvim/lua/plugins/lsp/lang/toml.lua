local utils = require("utils")

return {
  -- syntax highlight
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if opts.ensure_installed ~= "all" then
        opts.ensure_installed = utils.list_insert_unique(opts.ensure_installed, { "toml" })
      end
    end,
  },
  -- language server
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- install and config taplo
        taplo = {},
      },
    },
  },
}
