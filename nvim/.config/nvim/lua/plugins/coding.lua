return {
  -- Comment
  {
    'echasnovski/mini.comment',
    enabled = vim.fn.has 'nvim-0.10' ~= 1,
    event = { 'BufReadPost', 'BufNewFile' },
    dependencies = {
      'JoosepAlviste/nvim-ts-context-commentstring',
    },
    opts = {
      options = {
        custom_commentstring = function()
          return require('ts_context_commentstring.internal').calculate_commentstring() or vim.bo.commentstring
        end,
      },
    },
  },

  -- Surround
  {
    'echasnovski/mini.surround',
    event = { 'BufReadPost', 'BufNewFile' },
    opts = {
      mappings = {
        add = 'gsa', -- Add surrounding in Normal and Visual modes
        delete = 'gsd', -- Delete surrounding
        find = 'gsf', -- Find surrounding (to the right)
        find_left = 'gsF', -- Find surrounding (to the left)
        highlight = 'gsh', -- Highlight surrounding
        replace = 'gsc', -- Change surrounding
        update_n_lines = 'gsn', -- Update `n_lines`
      },
    },
  },

  -- Textobjects
  -- Surround
  {
    'echasnovski/mini.ai',
    event = { 'BufReadPost', 'BufNewFile' },
    opts = {},
  },

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
