-- NOTE:
-- Find more plugins here: https://neovimcraft.com/

return {
  -- Library used by other plugins
  { 'MunifTanjim/nui.nvim', lazy = true },
  { 'nvim-lua/plenary.nvim', lazy = true },
  { 'nvim-tree/nvim-web-devicons', lazy = true },

  -- Better vim.ui
  {
    'stevearc/dressing.nvim',
    event = { 'BufReadPost', 'BufNewFile' },
    init = function()
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.select = function(...)
        require('lazy').load { plugins = { 'dressing.nvim' } }
        return vim.ui.select(...)
      end
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.input = function(...)
        require('lazy').load { plugins = { 'dressing.nvim' } }
        return vim.ui.input(...)
      end
    end,
  },

  -- Better gx
  {
    'chrishrb/gx.nvim',
    event = { 'BufReadPost', 'BufNewFile' },
    dependencies = { 'nvim-lua/plenary.nvim' },
    cmd = { 'Browse' },
    keys = { { 'gx', '<cmd>Browse<cr>', mode = { 'n', 'x' } } },
    init = function()
      vim.g.netrw_nogx = 1
    end,
    config = true,
  },

  -- Session manager
  {
    'folke/persistence.nvim',
    event = 'BufReadPre',
    opts = { options = vim.opt.sessionoptions:get() },
    -- stylua: ignore
    keys = {
      { '<leader>qs', function() require('persistence').load() end,                desc = 'Restore Session' },
      { '<leader>ql', function() require('persistence').load({ last = true }) end, desc = 'Restore Last Session' },
      { '<leader>qd', function() require('persistence').stop() end,                desc = "Don't Save Current Session" },
    },
  },

  -- Keybindings popup
  {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    opts = {
      plugins = { spelling = true },
      defaults = {
        mode = { 'n', 'v' },
        ['g'] = { name = '+goto' },
        ['gs'] = { name = '+surround' },
        [']'] = { name = '+next' },
        ['['] = { name = '+prev' },
        ['<leader>b'] = { name = '+buffer' },
        ['<leader>c'] = { name = '+code' },
        ['<leader>f'] = { name = '+find' },
        ['<leader>g'] = { name = '+git' },
        ['<leader>gh'] = { name = '+hunks' },
        ['<leader>q'] = { name = '+quit' },
        ['<leader>t'] = { name = '+terminal' },
        ['<leader>u'] = { name = '+ui' },
        ['<leader>w'] = { name = '+workspace' },
        ['<leader><tab>'] = { name = '+tabs' },
      },
    },
    config = function(_, opts)
      local wk = require 'which-key'
      wk.setup(opts)
      wk.register(opts.defaults)
    end,
  },

  -- Resize windows
  {
    'mrjones2014/smart-splits.nvim',
    event = { 'BufReadPost', 'BufNewFile' },
    opts = {},
    keys = {
      { '<C-Up>', '<cmd>SmartResizeUp<cr>', 'Resize Up' },
      { '<C-Down>', '<cmd>SmartResizeDown<cr>', 'Resize Down' },
      { '<C-Left>', '<cmd>SmartResizeLeft<cr>', 'Resize Left' },
      { '<C-Right>', '<cmd>SmartResizeRight<cr>', 'Resize Right' },
    },
  },

  -- Smooth scrolling
  {
    'karb94/neoscroll.nvim',
    cond = vim.g.smooth_scroll,
    event = { 'BufReadPost', 'BufNewFile' },
    opts = {},
  },
}
