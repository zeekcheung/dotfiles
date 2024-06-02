return {
  -- Animation
  {
    'echasnovski/mini.animate',
    event = { 'BufReadPost', 'BufNewFile' },
    enabled = vim.g.mini_animate,
    config = function()
      vim.opt.mousescroll = 'ver:1,hor:1'
      require('mini.animate').setup {
        cursor = { enable = false },
        scroll = { enable = true },
        resize = { enable = false },
        open = { enable = false },
        close = { enable = false },
      }
    end,
  },

  -- Comment
  {
    'echasnovski/mini.comment',
    event = { 'BufReadPost', 'BufNewFile' },
    enabled = vim.fn.has 'nvim-0.10' ~= 1,
    opts = {},
  },

  -- Git hunk
  {
    'echasnovski/mini.diff',
    event = { 'BufReadPost', 'BufNewFile' },
    opts = {
      view = {
        style = 'sign',
        signs = {
          add = '▎',
          change = '▎',
          delete = '',
        },
      },
    },
  },

  -- Color highlight & Todo Highlight
  {
    'echasnovski/mini.hipatterns',
    event = { 'BufReadPost', 'BufNewFile' },
    opts = {},
    config = function()
      local hipatterns = require 'mini.hipatterns'
      hipatterns.setup {
        highlighters = {
          -- Highlight standalone 'FIXME', 'HACK', 'TODO', 'NOTE'
          fixme = { pattern = '%f[%w]()FIXME()%f[%W]', group = 'MiniHipatternsFixme' },
          hack = { pattern = '%f[%w]()HACK()%f[%W]', group = 'MiniHipatternsHack' },
          todo = { pattern = '%f[%w]()TODO()%f[%W]', group = 'MiniHipatternsTodo' },
          note = { pattern = '%f[%w]()NOTE()%f[%W]', group = 'MiniHipatternsNote' },

          -- Highlight hex color strings (`#rrggbb`) using that color
          hex_color = hipatterns.gen_highlighter.hex_color(),
        },
        delay = { text_change = 50 },
      }
    end,
  },

  -- Auto pairs
  {
    'echasnovski/mini.pairs',
    event = { 'BufNewFile', 'BufReadPost' },
    opts = {
      modes = { insert = true, command = true, terminal = true },
    },
  },

  -- Session
  {
    'echasnovski/mini.sessions',
    event = { 'VeryLazy' },
    config = function()
      require('mini.sessions').setup {
        verbose = { read = false, write = false, delete = false },
        hooks = {
          pre = {
            write = function()
              vim.cmd 'silent! Neotree close'
            end,
          },
        },
      }

      -- Session commands
      local create_user_command = vim.api.nvim_create_user_command
      create_user_command('SessionRead', function(opts)
        local session_name = opts.args == '' and 'last' or opts.args
        require('mini.sessions').read(session_name)
      end, { nargs = '?' })
      create_user_command('SessionWrite', function(opts)
        local session_name = opts.args == '' and 'last' or opts.args
        require('mini.sessions').write(session_name)
      end, { nargs = '?' })
      create_user_command('SessionDelete', function(opts)
        local session_name = opts.args == '' and 'last' or opts.args
        require('mini.sessions').delete(session_name)
      end, { nargs = '?' })
      create_user_command('SessionSelect', function()
        require('mini.sessions').select()
      end, { nargs = '?' })

      -- Auto write last session on VimLeave
      vim.api.nvim_create_autocmd('VimLeavePre', { command = 'SessionWrite' })
    end,
  },

  -- Dashboard
  {
    'echasnovski/mini.starter',
    event = { 'VimEnter' },
    opts = {
      evaluate_single = true,
      footer = 'Simplicity is the soul of efficiency.',
    },
  },

  -- Surround
  {
    'echasnovski/mini.surround',
    event = { 'BufReadPost', 'BufNewFile' },
    opts = {
      mappings = {
        add = 'gsa',
        delete = 'gsd',
        find = 'gsf',
        find_left = 'gsF',
        highlight = 'gsh',
        replace = 'gsc',
        update_n_lines = 'gsn',
      },
    },
  },
}
