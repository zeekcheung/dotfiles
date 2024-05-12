local Ui = require 'util.ui'
local icons = Ui.icons

return {

  -- Dashboard
  {
    'nvimdev/dashboard-nvim',
    event = 'VimEnter',
    dependencies = { 'nvim-lualine/lualine.nvim' },
    -- init = function()
    --   vim.opt.ruler = false
    --   vim.opt.showcmd = false
    -- end,
    opts = function()
      local logo = [[
███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝
]]

      logo = string.rep('\n', 1) .. logo .. '\n'

      local opts = {
        theme = 'doom',
        hide = {
          statusline = false,
          tabline = true,
          winbar = true,
        },
        config = {
          header = vim.split(logo, '\n'),
          -- stylua: ignore
          center = {
            { action = 'Telescope find_files', desc = ' Files', icon = ' ', key = 'f' },
            -- { action = "ene | startinsert", desc = " New file", icon = " ", key = "n" },
            { action = 'Telescope oldfiles', desc = ' Recent', icon = ' ', key = 'r' },
            { action = 'Telescope projects', desc = ' Projects', icon = ' ', key = 'p' },
            { action = "lua require('util').find_configs()", desc = ' Config', icon = ' ', key = 'c' },
            { action = "lua require('persistence').load()", desc = ' Session', icon = ' ', key = 's' },
            { action = 'Lazy', desc = ' Lazy', icon = '󰒲 ', key = 'l' },
            { action = 'qa', desc = ' Quit', icon = ' ', key = 'q' },
          },
          footer = function()
            local stats = require('lazy').stats()
            local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
            return {
              '⚡ Neovim loaded ' .. stats.loaded .. '/' .. stats.count .. ' plugins in ' .. ms .. 'ms',
            }
          end,
        },
      }

      for _, button in ipairs(opts.config.center) do
        button.desc = button.desc .. string.rep(' ', 40 - #button.desc)
        button.key_format = '  %s'
      end

      -- close Lazy and re-open when the dashboard is ready
      if vim.o.filetype == 'lazy' then
        vim.cmd.close()
        vim.api.nvim_create_autocmd('User', {
          pattern = 'DashboardLoaded',
          callback = function()
            require('lazy').show()
          end,
        })
      end

      return opts
    end,
  },

  -- Status line
  {
    'nvim-lualine/lualine.nvim',
    event = 'VeryLazy',
    opts = function()
      local statusline = {
        lualine_a = {
          {
            'mode',
            fmt = function(str)
              return str:sub(1, 1)
            end,
          },
        },
        lualine_b = {
          {
            'branch',
            icon = '',
            on_click = function()
              vim.cmd 'Telescope git_branches'
            end,
            color = { bg = 'NONE' },
          },
        },
        lualine_c = {
          { 'filetype', icon_only = true, separator = '', padding = { left = 1, right = 0 } },
          { 'filename', padding = { left = 0, right = 1 } },
          {
            'diagnostics',
            symbols = {
              error = icons.diagnostics.Error,
              warn = icons.diagnostics.Warn,
              info = icons.diagnostics.Info,
              hint = icons.diagnostics.Hint,
            },
          },
        },
        lualine_x = {
          -- codeium
          {
            'vim.fn["codeium#GetStatusString"]()',
            cond = function()
              return vim.g.codeium_plugin_enabled
            end,
            fmt = function(str)
              return icons.kinds.Codeium .. str
            end,
            on_click = function()
              vim.cmd 'CodeiumToggle'
            end,
          },
          -- lsp
          {
            function()
              local buf_ft = vim.api.nvim_buf_get_option(0, 'filetype')
              local clients = vim.lsp.get_active_clients()
              for _, client in ipairs(clients) do
                local filetypes = client.config.filetypes
                if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
                  return client.name
                end
              end
            end,
            icon = '󰅡',
            on_click = function()
              vim.cmd 'LspInfo'
            end,
          },
          -- 'encoding',
          -- 'fileformat',
          -- 'filetype',
        },
      }

      -- local winbar = {
      --   lualine_c = {
      --     { 'filetype', icon_only = true,      separator = '', padding = { left = 2, right = 0 } },
      --     { 'filename', padding = { left = 0 } },
      --   },
      -- }

      return {
        options = {
          theme = 'auto',
          globalstatus = true,
          disabled_filetypes = {
            statusline = { 'dashboard' },
            winbar = { 'dashboard', 'neo-tree', 'toggleterm' },
          },
          component_separators = '',
          section_separators = '',
        },
        sections = statusline,
        -- winbar = winbar,
        -- inactive_winbar = winbar,
        extensions = { 'lazy', 'mason', 'neo-tree', 'toggleterm' },
      }
    end,
  },

  -- Status column
  {
    'luukvbaal/statuscol.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    branch = vim.fn.has 'nvim-0.10' == 1 and '0.10' or 'main',
    init = function()
      -- auto change numberwidth based on the lines of current buffer
      vim.api.nvim_create_autocmd('FileType', {
        pattern = '*',
        callback = function()
          -- get the lines of current buffer
          local lines = vim.api.nvim_buf_line_count(0)
          if lines > 100 then
            vim.opt_local.numberwidth = 5
          elseif lines > 1000 then
            vim.opt_local.numberwidth = 6
          end
        end,
      })
    end,
    config = function()
      local builtin = require 'statuscol.builtin'
      require('statuscol').setup {
        relculright = true,
        ft_ignore = { 'help', 'dashboard', 'NeoTree' },
        segments = {
          { sign = { name = { 'GitSigns', 'todo*' }, namespace = { 'git', 'todo' } }, click = 'v:lua.ScSa' },
          {
            text = { builtin.lnumfunc, ' ' },
            condition = { true, builtin.not_empty },
            click = 'v:lua.ScLa',
          },
          {
            sign = { name = { 'Diagnostic' }, namespace = { 'diagnostic' } },
            condition = { vim.g.diagnostic_opts.signs },
            click = 'v:lua.ScSa',
          },
          -- {
          --   text = { builtin.foldfunc },
          --   condition = { vim.opt.foldcolumn:get() ~= '0' },
          --   click = 'v:lua.ScFa',
          -- },
        },
      }
    end,
  },

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

  -- Better notifications
  {
    'rcarriga/nvim-notify',
    event = 'VeryLazy',
    enabled = false,
    keys = {
      {
        '<leader>un',
        -- stylua: ignore
        function() require('notify').dismiss { silent = true, pending = true } end,
        desc = 'Dismiss all Notifications',
      },
    },
    opts = {
      timeout = 2000,
      top_down = false,
      max_height = function()
        return math.floor(vim.o.lines * 0.75)
      end,
      max_width = function()
        return math.floor(vim.o.columns * 0.75)
      end,
      on_open = function(win)
        vim.api.nvim_win_set_config(win, { zindex = 100 })
      end,
    },
    config = function(_, opts)
      if vim.g.transparent_background then
        opts.background_colour = '#000000'
      end

      require('notify').setup(opts)
    end,
  },

  -- Git highlight
  {
    'lewis6991/gitsigns.nvim',
    event = { 'BufReadPost', 'BufNewFile' },
    opts = {
      signs = {
        add = { text = '▎' },
        change = { text = '▎' },
        delete = { text = '' },
        topdelete = { text = '' },
        changedelete = { text = '▎' },
        untracked = { text = '▎' },
      },
      on_attach = function(buffer)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
        end

        -- stylua: ignore start
        map('n', ']h', gs.next_hunk, 'Next Hunk')
        map('n', '[h', gs.prev_hunk, 'Prev Hunk')
        map({ 'n', 'v' }, '<leader>ghs', ':Gitsigns stage_hunk<CR>', 'Stage Hunk')
        map({ 'n', 'v' }, '<leader>ghr', ':Gitsigns reset_hunk<CR>', 'Reset Hunk')
        map('n', '<leader>ghS', gs.stage_buffer, 'Stage Buffer')
        map('n', '<leader>ghu', gs.undo_stage_hunk, 'Undo Stage Hunk')
        map('n', '<leader>ghR', gs.reset_buffer, 'Reset Buffer')
        map('n', '<leader>ghp', gs.preview_hunk, 'Preview Hunk')
        map('n', '<leader>ghb', function() gs.blame_line({ full = true }) end, 'Blame Line')
        map('n', '<leader>ghd', gs.diffthis, 'Diff This')
        map('n', '<leader>ghD', function() gs.diffthis('~') end, 'Diff This ~')
        map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>', 'GitSigns Select Hunk')
      end,
    },
  },

  -- TODO highlight
  {
    'folke/todo-comments.nvim',
    cmd = { 'TodoTrouble', 'TodoTelescope' },
    event = { 'BufReadPost', 'BufNewFile' },
    opts = {
      signs = false,
    },
    -- stylua: ignore
    keys = {
      { ']t', function() require('todo-comments').jump_next() end, desc = 'Next todo comment' },
      { '[t', function() require('todo-comments').jump_prev() end, desc = 'Previous todo comment' },
    },
  },

  -- Color highlight
  {
    'NvChad/nvim-colorizer.lua',
    event = { 'BufReadPost', 'BufNewFile' },
    config = true,
  },

  -- Bracket highlight
  {
    'HiPhish/rainbow-delimiters.nvim',
    event = { 'BufReadPost', 'BufNewFile' },
    config = function()
      vim.g.rainbow_delimiters = {
        highlight = {
          'RainbowDelimiterRed',
          'RainbowDelimiterYellow',
          'RainbowDelimiterGreen',
          'RainbowDelimiterBlue',
          'RainbowDelimiterOrange',
          'RainbowDelimiterViolet',
        },
      }
    end,
  },

  -- Better markdown headlines
  {
    'lukas-reineke/headlines.nvim',
    cond = false,
    opts = function()
      local opts = {}

      for _, ft in ipairs { 'markdown', 'norg', 'rmd', 'org' } do
        opts[ft] = {
          headline_highlights = {},
        }
        for i = 1, 6 do
          local hl = 'Headline' .. i
          vim.api.nvim_set_hl(0, hl, { link = 'Headline', default = true })
          table.insert(opts[ft].headline_highlights, hl)
        end
      end
      return opts
    end,
    ft = { 'markdown', 'norg', 'rmd', 'org' },
    config = function(_, opts)
      opts.markdown.fat_headline_upper_string = '▄'
      opts.markdown.fat_headline_lower_string = '▀'

      -- PERF: schedule to prevent headlines slowing down opening a file
      vim.schedule(function()
        require('headlines').setup(opts)
        require('headlines').refresh()
      end)
    end,
  },

  -- Smooth scrolling
  {
    'karb94/neoscroll.nvim',
    cond = vim.g.smooth_scroll,
    event = { 'BufReadPost', 'BufNewFile' },
    opts = {},
  },
}
