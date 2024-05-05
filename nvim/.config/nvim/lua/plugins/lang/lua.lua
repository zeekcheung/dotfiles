return {
  -- Syntax highlighting
  {
    'nvim-treesitter/nvim-treesitter',
    opts = function(_, opts)
      if type(opts.ensure_installed) == 'table' then
        vim.list_extend(opts.ensure_installed, { 'lua', 'luadoc', 'luap' })
      end
    end,
  },

  -- Language server
  {
    'neovim/nvim-lspconfig',
    opts = {
      -- Make sure mason installs the server
      servers = {
        lua_ls = {
          Lua = {
            telemetry = { enable = false },
            diagnostics = {
              globals = { 'vim' },
            },
            workspace = {
              checkThirdParty = false,
              library = {
                vim.api.nvim_get_runtime_file('lua', true),
              },
              maxPreload = 100000,
              preloadFileSize = 10000,
            },
          },
        },
      },
    },
  },

  {
    'williamboman/mason.nvim',
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { 'stylua' })
    end,
  },

  -- Formatter
  {
    'stevearc/conform.nvim',
    optional = true,
    opts = {
      formatters_by_ft = {
        -- lua = { 'stylua' },
        -- NOTE: use lus_ls to format, instead of stylua
      },
    },
  },
}
