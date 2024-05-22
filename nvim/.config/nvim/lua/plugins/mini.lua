return {
  'echasnovski/mini.nvim',
  event = { 'VimEnter', 'VeryLazy' },
  config = function()
    -- Animation
    vim.opt.mousescroll = 'ver:1,hor:1'
    require('mini.animate').setup {
      cursor = { enable = false },
      scroll = { enable = true },
      resize = { enable = false },
      open = { enable = false },
      close = { enable = false },
    }

    -- Comment
    if vim.fn.has 'nvim-0.10' ~= 1 then
      require('mini.comment').setup()
    end

    -- Highlight cursor word
    require('mini.cursorword').setup()
    vim.api.nvim_set_hl(0, 'MiniCursorword', { link = 'LspReferenceRead' })
    -- vim.api.nvim_set_hl(0, 'MiniCursorwordCurrent', { link = 'LspReferenceText' })

    -- Git hunk
    require('mini.diff').setup {
      view = {
        style = 'sign',
        signs = {
          add = '▎',
          change = '▎',
          delete = '',
        },
      },
    }

    -- Color highlight & Todo Highlight
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

    -- Auto pairs
    require('mini.pairs').setup {
      modes = { insert = true, command = true, terminal = true },
    }

    -- Session
    require('mini.sessions').setup {
      verbose = { read = false, write = false, delete = false },
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

    -- Dashboard
    require('mini.starter').setup {
      footer = 'Simplicity is the soul of efficiency.',
    }

    -- Surround
    require('mini.surround').setup {
      mappings = {
        add = 'gsa',
        delete = 'gsd',
        find = 'gsf',
        find_left = 'gsF',
        highlight = 'gsh',
        replace = 'gsc',
        update_n_lines = 'gsn',
      },
    }
  end,
}
