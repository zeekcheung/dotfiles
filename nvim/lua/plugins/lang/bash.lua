return {
  -- Language server
  {
    'neovim/nvim-lspconfig',
    opts = {
      -- Make sure mason installs the server
      servers = {
        bashls = {
          filetypes = { 'sh', 'zsh' },
        },
      },
    },
  },

  {
    'williamboman/mason.nvim',
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { 'shfmt', 'shellcheck' })
    end,
  },

  -- Formatter
  {
    'stevearc/conform.nvim',
    optional = true,
    opts = {
      formatters_by_ft = {
        sh = { 'shfmt' },
        zsh = { 'shfmt' },
      },
    },
  },

  -- Linter
  {
    'mfussenegger/nvim-lint',
    optional = true,
    opts = {
      linters_by_ft = {
        sh = { 'shellcheck' },
        -- zsh = { 'shellcheck' },
      },
    },
  },
}
