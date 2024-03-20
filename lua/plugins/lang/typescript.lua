return {
  {
    'nvim-treesitter/nvim-treesitter',
    opts = function(_, opts)
      if type(opts.ensure_installed) == 'table' then
        vim.list_extend(opts.ensure_installed, { 'typescript', 'tsx' })
      end
    end,
  },

  {
    'neovim/nvim-lspconfig',
    opts = {
      -- Make sure mason installs the server
      servers = {
        tsserver = {
          keys = {
            {
              '<leader>co',
              function()
                vim.lsp.buf.code_action {
                  apply = true,
                  context = {
                    only = { 'source.organizeImports.ts' },
                    diagnostics = {},
                  },
                }
              end,
              desc = 'Organize Imports',
            },
            {
              '<leader>cR',
              function()
                vim.lsp.buf.code_action {
                  apply = true,
                  context = {
                    only = { 'source.removeUnused.ts' },
                    diagnostics = {},
                  },
                }
              end,
              desc = 'Remove Unused Imports',
            },
          },
          settings = {
            typescript = {
              format = {
                indentSize = vim.o.shiftwidth,
                convertTabsToSpaces = vim.o.expandtab,
                tabSize = vim.o.tabstop,
              },
            },
            javascript = {
              format = {
                indentSize = vim.o.shiftwidth,
                convertTabsToSpaces = vim.o.expandtab,
                tabSize = vim.o.tabstop,
              },
            },
            completions = {
              completeFunctionCalls = true,
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
      vim.list_extend(opts.ensure_installed, { 'prettier', 'eslint_d' })
    end,
  },

  {
    'stevearc/conform.nvim',
    optional = true,
    opts = {
      formatters_by_ft = {
        javascript = { 'prettier' },
        javascriptreact = { 'prettier' },
        typescript = { 'prettier' },
        typescriptreact = { 'prettier' },
        vue = { 'prettier' },
        css = { 'prettier' },
        scss = { 'prettier' },
        less = { 'prettier' },
        html = { 'prettier' },
        graphql = { 'prettier' },
      },
    },
  },

  {
    'mfussenegger/nvim-lint',
    optional = true,
    opts = {
      linters_by_ft = {
        javascript = { 'eslint_d' },
        jaavascriptreact = { 'eslint_d' },
        typescript = { 'eslint_d' },
        typescriptreact = { 'eslint_d' },
      },
    },
  },
}
