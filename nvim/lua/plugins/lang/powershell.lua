return {
  -- Syntax highlighting
  { 'PProvost/vim-ps1', ft = 'ps1' },

  -- Language Server
  {
    'neovim/nvim-lspconfig',
    opts = {
      -- make sure mason installs the server
      servers = {
        powershell_es = {
          settings = {},
        },
      },
    },
  },

  -- Formatter
  {
    'stevearc/conform.nvim',
    optional = true,
    opts = function(_, opts)
      -- Disable lsp format
      if type(opts.lsp_ignore_filetypes) == 'table' then
        vim.list_extend(opts.lsp_ignore_filetypes, { 'ps1' })
      end
    end,
  },
}
