return {
  -- Rename symbols
  {
    'smjonas/inc-rename.nvim',
    event = { 'BufReadPost', 'BufNewFile' },
    cmd = 'IncRename',
    keys = {
      { '<leader>rn', ':IncRename ', desc = 'Rename' },
    },
    config = true,
  },

  -- Replace string
  {
    'nvim-pack/nvim-spectre',
    cmd = 'Spectre',
    event = { 'BufReadPost', 'BufNewFile' },
    keys = {
      { '<leader>h', '<cmd>Spectre<cr>', desc = 'Replace' },
    },
  },
}
