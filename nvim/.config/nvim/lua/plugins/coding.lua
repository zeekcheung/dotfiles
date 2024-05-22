return {
  -- AI completion
  {
    'Exafunction/codeium.vim',
    event = 'VeryLazy',
    cond = vim.g.codeium_plugin_enabled,
    -- stylua: ignore
    config = function()
      vim.keymap.set('i', '<C-g>', function() return vim.fn['codeium#Accept']() end, { expr = true, silent = true })
      vim.keymap.set('i', '<c-;>', function() return vim.fn['codeium#CycleCompletions'](1) end,
        { expr = true, silent = true })
      vim.keymap.set('i', '<c-,>', function() return vim.fn['codeium#CycleCompletions'](-1) end,
        { expr = true, silent = true })
      vim.keymap.set('i', '<c-x>', function() return vim.fn['codeium#Clear']() end, { expr = true, silent = true })
    end,
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
}
