-- NOTE:
-- Find more plugins here: https://neovimcraft.com/

local Util = require 'util'
local Lualine = require 'util.lualine'

local map = Util.silent_map
local Ui = require 'util.ui'
local icons = Ui.icons

return {
  -- Library used by other plugins
  { 'MunifTanjim/nui.nvim', lazy = true },
  { 'nvim-lua/plenary.nvim', lazy = true },
  { 'nvim-tree/nvim-web-devicons', lazy = true },

  -- Dashboard
  {
    'nvimdev/dashboard-nvim',
    event = 'VimEnter',
    init = function()
      vim.opt.ruler = false
      vim.opt.showcmd = false
    end,
    opts = function()
      local logo = [[
███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝
]]

      logo = string.rep('\n', 2) .. logo .. '\n'

      local opts = {
        theme = 'doom',
        hide = {
          -- this is taken care of by lualine
          -- enabling this messes up the actual laststatus setting after loading a file
          statusline = false,
          tabline = true,
          winbar = true,
        },
        config = {
          header = vim.split(logo, '\n'),
          -- stylua: ignore
          center = {
            { action = "Telescope find_files", desc = " Files", icon = " ", key = "f" },
            -- { action = "ene | startinsert", desc = " New file", icon = " ", key = "n" },
            { action = "Telescope oldfiles", desc = " Recent", icon = " ", key = "r" },
            { action = "Telescope projects", desc = " Projects", icon = " ", key = "p" },
            { action = "lua require('util').find_configs()", desc = " Config", icon = " ", key = "c" },
            { action = "lua require('persistence').load()", desc = " Session", icon = " ", key = "s" },
            { action = "Lazy", desc = " Lazy", icon = "󰒲 ", key = "l" },
            { action = "qa", desc = " Quit", icon = " ", key = "q" },
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

  -- File explorer
  {
    'nvim-neo-tree/neo-tree.nvim',
    branch = 'v3.x',
    cmd = 'Neotree',
    keys = {
      {
        '<leader>e',
        function()
          require('neo-tree.command').execute { toggle = true, dir = vim.loop.cwd() }
        end,
        desc = 'Explorer',
      },
      -- { '<C-e>', '<leader>e', desc = 'Explorer', remap = true },
    },
    deactivate = function()
      vim.cmd [[Neotree close]]
    end,
    init = function()
      if vim.fn.argc(-1) == 1 then
        local stat = vim.loop.fs_stat(vim.fn.argv(0))
        if stat and stat.type == 'directory' then
          require 'neo-tree'
        end
      end

      -- Disable netrw
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1
    end,
    opts = {
      use_popups_for_input = true,
      popup_border_style = 'NC',
      enable_git_status = true,
      sources = { 'filesystem', 'buffers', 'git_status', 'document_symbols' },
      source_selector = {
        winbar = true,
        content_layout = 'center',
        tabs_layout = 'equal',
        show_separator_on_edge = false,
        sources = {
          { source = 'filesystem', display_name = '󰉓' },
          { source = 'buffers', display_name = '󰈚' },
          { source = 'git_status', display_name = '󰊢' },
          { source = 'document_symbols', display_name = '' },
        },
      },
      open_files_do_not_replace_types = { 'terminal', 'Trouble', 'qf', 'Outline' },
      default_component_configs = {
        indent = {
          with_expanders = false, -- if nil and file nesting is enabled, will enable expanders
          expander_collapsed = '',
          expander_expanded = '',
          expander_highlight = 'NeoTreeExpander',
        },
        modified = { symbol = icons.file.modified },
        git_status = {
          symbols = {
            added = icons.git.added,
            deleted = icons.git.removed,
            modified = icons.git.modified,
            renamed = icons.git.renamed,
            untracked = icons.git.untracked,
            ignored = icons.git.ignored,
            unstaged = icons.git.unstaged,
            staged = icons.git.staged,
            conflict = icons.git.conflict,
          },
        },
        diagnostics = {
          symbols = {
            hint = icons.diagnostics.Hint,
            info = icons.diagnostics.Info,
            warn = icons.diagnostics.Warn,
            error = icons.diagnostics.Error,
          },
        },
      },
      window = {
        position = 'left',
        width = 30,
        mappings = {
          ['<Tab>'] = 'next_source',
          ['<S-Tab>'] = 'prev_source',
          ['s'] = 'none', -- disable default mappings
          ['<leftrelease>'] = 'open', -- open node with single left click
          ['za'] = 'toggle_node',
        },
      },
      filesystem = {
        bind_to_cwd = false,
        follow_current_file = { enabled = true },
        use_libuv_file_watcher = true,
        filtered_items = {
          visible = true,
          show_hidden_count = true,
          hide_dotfiles = false,
          hide_gitignored = false,
          hide_by_name = {
            -- '.git',
            -- '.DS_Store',
            -- 'thumbs.db',
          },
          never_show = {},
        },
      },
      buffers = {
        window = {
          mappings = {
            ['d'] = 'buffer_delete',
          },
        },
      },

      event_handlers = {
        {
          event = 'neo_tree_buffer_enter',
          handler = function()
            -- hide signcolumn
            vim.opt.signcolumn = 'no'
          end,
        },
      },
    },
    config = function(_, opts)
      require('neo-tree').setup(opts)

      -- refresh git status after lazygit is closed
      vim.api.nvim_create_autocmd('TermClose', {
        pattern = '*lazygit',
        callback = function()
          if package.loaded['neo-tree.sources.git_status'] then
            require('neo-tree.sources.git_status').refresh()
          end
        end,
      })
    end,
  },

  -- Statusline
  {
    'nvim-lualine/lualine.nvim',
    enabled = true,
    event = 'VeryLazy',
    init = function()
      vim.opt.showmode = false
      vim.g.lualine_laststatus = vim.o.laststatus
      if vim.fn.argc(-1) > 0 then
        -- set an empty statusline till lualine loads
        vim.o.statusline = ' '
      else
        -- hide the statusline on the starter page
        vim.o.laststatus = 0
      end
    end,
    opts = function()
      vim.o.laststatus = vim.g.lualine_laststatus

      return {
        options = {
          theme = 'auto',
          globalstatus = true,
          disabled_filetypes = { statusline = { 'dashboard', 'alpha', 'starter' } },
          component_separators = '',
          -- section_separators = '',
          -- section_separators = { left = '', right = '' },
        },
        sections = {
          lualine_a = {
            'mode',
          },
          lualine_b = {
            'branch',
          },
          lualine_c = {
            Lualine.filetype_icon(),
            'filename',
            Lualine.diagnostics(),
            -- '%=',
          },
          lualine_x = {
            Lualine.codeium(),
            Lualine.lspinfo(),
            Lualine.formatters(),
            Lualine.linters(),
            Lualine.filetype(),
            -- Lualine.indent(),
            -- 'encoding',
            -- Lualine.fileformat(),
          },
          lualine_y = {
            'progress',
          },
          lualine_z = {
            'location',
          },
        },
        extensions = { 'neo-tree', 'lazy' },
      }
    end,
  },

  -- Status column
  {
    'luukvbaal/statuscol.nvim',
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
        segments = {
          {
            text = { builtin.foldfunc },
            condition = { vim.opt.foldcolumn:get() ~= '0' },
            click = 'v:lua.ScFa',
          },
          -- {
          --   sign = { namespace = { 'diagnostic' }, maxwidth = 1, auto = true },
          --   click = 'v:lua.ScSa',
          -- },
          {
            text = { builtin.lnumfunc, ' ' },
            condition = { true, builtin.not_empty },
            click = 'v:lua.ScLa',
          },
          { text = { '%s' }, click = 'v:lua.ScSa' },
        },
      }
    end,
  },

  -- Fuzzy finder
  {
    'nvim-telescope/telescope.nvim',
    cmd = 'Telescope',
    version = false, -- telescope did only one release, so use HEAD for now
    init = function()
      -- Avoid selected file opens in insert mode directly
      vim.api.nvim_create_autocmd('WinLeave', {
        callback = function()
          if vim.bo.ft == 'TelescopePrompt' and vim.fn.mode() == 'i' then
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', true, false, true), 'i', false)
          end
        end,
      })
    end,
    dependencies = {
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
        enabled = vim.fn.executable 'make' == 1,
        config = function()
          require('telescope').load_extension 'fzf'
        end,
      },
      {
        'ahmedkhalf/project.nvim',
        event = 'VeryLazy',
        opts = {
          manual_mode = false,
        },
        config = function(_, opts)
          require('project_nvim').setup(opts)
          require('telescope').load_extension 'projects'
        end,
        keys = {
          { '<leader>fp', '<Cmd>Telescope projects<CR>', desc = 'Projects' },
        },
      },
    },
    opts = function()
      local actions = require 'telescope.actions'

      return {
        defaults = {
          prompt_prefix = '   ',
          selection_caret = '❯ ',
          path_display = { 'truncate' },
          sorting_strategy = 'ascending',
          layout_config = {
            horizontal = { prompt_position = 'top', preview_width = 0.55 },
            vertical = { mirror = false },
            -- width = 0.87,
            -- height = 0.80,
            -- preview_cutoff = 0, -- always show file preview
          },
          mappings = {
            n = { ['q'] = actions.close },
            i = {
              ['<C-j>'] = {
                actions.move_selection_next,
                type = 'action',
                opts = { nowait = true, silent = true },
              },
              ['<C-k>'] = {
                actions.move_selection_previous,
                type = 'action',
                opts = { nowait = true, silent = true },
              },
            },
          },
        },
        pickers = {
          buffers = {
            initial_mode = 'normal',
            mappings = {
              n = {
                ['d'] = 'delete_buffer',
              },
            },
          },
        },
      }
    end,
    keys = function()
      -- See `:help telescope.builtin`
      local builtin = require 'telescope.builtin'
      -- stylua: ignore
      return {
        { '<C-p>', builtin.find_files, desc = 'Files' },
        {
          "<leader><leader>",
          "<cmd>Telescope buffers sort_mru=true sort_lastused=true<cr>",
          desc = "Switch Buffer",
        },
        { '<leader>/', builtin.live_grep, desc = 'Words' },
        { '<leader>fa', builtin.autocommands, desc = 'Autocmds' },
        { '<leader>fb', builtin.buffers, desc = 'Buffers' },
        { '<leader>fc', function()
          builtin.find_files { cwd = vim.fn.stdpath 'config' }
        end, desc = 'Config' },
        { '<leader>fd', function()
          builtin.diagnostics { bufnr = 0 }
        end, desc = 'Diagnostics' },
        { '<leader>fD', builtin.diagnostics, desc = 'Workspace diagnostics' },
        { '<leader>ff', builtin.find_files, desc = 'Files' },
        { '<leader>fh', builtin.help_tags, desc = 'Help Pages' },
        { '<leader>fk', builtin.keymaps, desc = 'Key Maps' },
        { '<leader>fo', builtin.oldfiles, desc = 'Recent Files' },
        { '<leader>fr', builtin.registers, desc = 'Registers' },
        { '<leader>fw', builtin.live_grep, desc = 'Words' },
        { '<leader>gb', builtin.git_branches, desc = 'Git Branches' },
        { '<leader>gc', builtin.git_commits, desc = 'Git commits' },
        { '<leader>gf', builtin.git_files, desc = 'Git files' },
        { '<leader>gs', builtin.git_stash, desc = 'Git statsh' },
        { '<leader>gt', builtin.git_status, desc = 'Git status' },
        { '<leader>uc', function()
          builtin.colorscheme { enable_preview = true }
        end, desc = 'Colorscheme' },
      }
    end,
  },

  -- Terminal
  {
    'akinsho/toggleterm.nvim',
    version = '*',
    config = function()
      local toggleterm = require 'toggleterm'

      local newterm_opts = {
        horizontal = { size = '10', key = '\\' },
        vertical = { size = '50', key = '|' },
      }

      toggleterm.setup {
        -- open_mapping = [[<F7>]],
        size = 10,
        shading_factor = 2,
        direction = 'float',
        float_opts = { border = 'rounded' },
        autochdir = true,
        highlights = {
          Normal = { link = 'Normal' },
          NormalNC = { link = 'NormalNC' },
          NormalFloat = { link = 'NormalFloat' },
          FloatBorder = { link = 'FloatBorder' },
          StatusLine = { link = 'StatusLine' },
          StatusLineNC = { link = 'StatusLineNC' },
          WinBar = { link = 'WinBar' },
          WinBarNC = { link = 'WinBarNC' },
        },
        on_create = function(term)
          -- print(vim.inspect(term, { depth = 2 }))
          local id = term.id
          local direction = term.direction
          local bufnr = term.bufnr

          vim.wo.foldcolumn = '0'
          vim.wo.signcolumn = 'no'

          -- close terminal window and exit running progress
          map('n', 'q', '<cmd>bd!<CR>', { buffer = bufnr, noremap = true, silent = true })

          if direction ~= 'float' then
            local set_newterm_keymap = function(direction)
              local opts = newterm_opts[direction]
              map('n', opts.key, function()
                id = id + 1
                vim.cmd(id .. 'ToggleTerm size=' .. opts.size .. ' direction=' .. direction)
              end, { buffer = bufnr, noremap = true, silent = true })
            end

            set_newterm_keymap 'horizontal'
            set_newterm_keymap 'vertical'
          end
        end,
      }

      if vim.fn.executable 'lazygit' == 1 then
        local Terminal = require('toggleterm.terminal').Terminal

        local lazygit = Terminal:new {
          hidden = true,
          direction = 'float',
          -- function to run on opening the terminal
          on_open = function(term)
            vim.cmd 'startinsert!'
            map('n', 'q', '<cmd>close<CR>', { buffer = term.bufnr, noremap = true, silent = true })
          end,
          -- function to run on closing the terminal
          on_close = function(term)
            vim.cmd 'startinsert!'
          end,
        }

        function _lazygit_toggle()
          lazygit.cmd = 'cd ' .. vim.fn.getcwd() .. ' && lazygit'
          lazygit:toggle()
        end

        map('n', '<leader>gg', '<cmd>lua _lazygit_toggle()<CR>', { desc = 'lazygit' })
      end

      map('t', '<esc>', [[<C-\><C-n>]])
      map('n', '<leader>tf', '<cmd>ToggleTerm direction=float<cr>', { desc = 'ToggleTerm float' })
      -- stylua: ignore
      map( 'n', '<leader>th', '<cmd>ToggleTerm size=' .. newterm_opts['horizontal'].size .. ' direction=horizontal<cr>', { desc = 'ToggleTerm horizontal split' })
      -- stylua: ignore
      map('n', '<leader>tv', '<cmd>ToggleTerm size=' .. newterm_opts['vertical'].size .. ' direction=vertical<cr>', { desc = 'ToggleTerm vertical split' })
    end,
  },

  -- Better vim.ui
  {
    'stevearc/dressing.nvim',
    lazy = true,
    init = function()
      vim.ui.select = function(...)
        require('lazy').load { plugins = { 'dressing.nvim' } }
        return vim.ui.select(...)
      end
      vim.ui.input = function(...)
        require('lazy').load { plugins = { 'dressing.nvim' } }
        return vim.ui.input(...)
      end
    end,
  },

  -- Better notifications
  {
    'rcarriga/nvim-notify',
    enabled = true,
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
    event = { 'BufReadPre', 'BufNewFile' },
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
        map("n", "]h", gs.next_hunk, "Next Hunk")
        map("n", "[h", gs.prev_hunk, "Prev Hunk")
        map({ "n", "v" }, "<leader>ghs", ":Gitsigns stage_hunk<CR>", "Stage Hunk")
        map({ "n", "v" }, "<leader>ghr", ":Gitsigns reset_hunk<CR>", "Reset Hunk")
        map("n", "<leader>ghS", gs.stage_buffer, "Stage Buffer")
        map("n", "<leader>ghu", gs.undo_stage_hunk, "Undo Stage Hunk")
        map("n", "<leader>ghR", gs.reset_buffer, "Reset Buffer")
        map("n", "<leader>ghp", gs.preview_hunk, "Preview Hunk")
        map("n", "<leader>ghb", function() gs.blame_line({ full = true }) end, "Blame Line")
        map("n", "<leader>ghd", gs.diffthis, "Diff This")
        map("n", "<leader>ghD", function() gs.diffthis("~") end, "Diff This ~")
        map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "GitSigns Select Hunk")
      end,
    },
  },

  -- TODO highlight
  {
    'folke/todo-comments.nvim',
    cmd = { 'TodoTrouble', 'TodoTelescope' },
    event = { 'BufReadPre', 'BufNewFile' },
    config = true,
    -- stylua: ignore
    keys = {
      { "]t", function() require("todo-comments").jump_next() end, desc = "Next todo comment" },
      { "[t", function() require("todo-comments").jump_prev() end, desc = "Previous todo comment" },
    },
  },

  -- Word highlight
  {
    'RRethy/vim-illuminate',
    event = { 'BufReadPre', 'BufNewFile' },
    opts = {
      providers = {
        'regex',
        'lsp',
        'treesitter',
      },
      delay = 200,
      large_file_cutoff = 2000,
      large_file_overrides = {
        providers = { 'lsp' },
      },
    },
    config = function(_, opts)
      require('illuminate').configure(opts)

      local function map(key, dir, buffer)
        vim.keymap.set('n', key, function()
          require('illuminate')['goto_' .. dir .. '_reference'](false)
        end, { desc = dir:sub(1, 1):upper() .. dir:sub(2) .. ' Reference', buffer = buffer })
      end

      map(']]', 'next')
      map('[[', 'prev')

      -- also set it after loading ftplugins, since a lot overwrite [[ and ]]
      vim.api.nvim_create_autocmd('FileType', {
        callback = function()
          local buffer = vim.api.nvim_get_current_buf()
          map(']]', 'next', buffer)
          map('[[', 'prev', buffer)
        end,
      })
    end,
    keys = {
      { ']]', desc = 'Next Reference' },
      { '[[', desc = 'Prev Reference' },
    },
  },

  -- Color highlight
  {
    'NvChad/nvim-colorizer.lua',
    event = { 'BufReadPre', 'BufNewFile' },
    config = true,
  },

  -- Bracket highlight
  {
    'HiPhish/rainbow-delimiters.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
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
        ['<leader>r'] = { name = '+runner' },
        ['<leader>s'] = { name = '+search' },
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

  -- Comment
  {
    'echasnovski/mini.comment',
    event = { 'BufReadPre', 'BufNewFile' },
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
    event = { 'BufReadPre', 'BufNewFile' },
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

  -- Auto pairs
  {
    'echasnovski/mini.pairs',
    event = { 'BufReadPre', 'BufNewFile' },
    opts = {},
    keys = {
      {
        '<leader>up',
        function()
          local Util = require 'lazy.core.util'
          vim.g.minipairs_disable = not vim.g.minipairs_disable
          if vim.g.minipairs_disable then
            vim.notify 'Disabled auto pairs'
          else
            vim.notify 'Enabled auto pairs'
          end
        end,
        desc = 'Toggle auto pairs',
      },
    },
  },

  -- Rename symbols
  {
    'smjonas/inc-rename.nvim',
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
    event = { 'BufReadPre', 'BufNewFile' },
    keys = {
      {
        '<leader>sr',
        function()
          require('spectre').open()
        end,
        desc = 'Replace in files (Spectre)',
      },
    },
  },

  -- AI completion
  {
    'Exafunction/codeium.vim',
    cond = vim.g.codeium_plugin_enabled,
    event = { 'VeryLazy' },
    -- stylua: ignore
    config = function (_, opts)
      vim.keymap.set('i', '<C-g>', function() return vim.fn['codeium#Accept']() end, { expr = true, silent = true })
      vim.keymap.set('i', '<c-;>', function() return vim.fn['codeium#CycleCompletions'](1) end, { expr = true, silent = true })
      vim.keymap.set('i', '<c-,>', function() return vim.fn['codeium#CycleCompletions'](-1) end, { expr = true, silent = true })
      vim.keymap.set('i', '<c-x>', function() return vim.fn['codeium#Clear']() end, { expr = true, silent = true })
    end,
  },

  -- Session manager
  {
    'folke/persistence.nvim',
    event = 'BufReadPre',
    opts = { options = vim.opt.sessionoptions:get() },
    -- stylua: ignore
    keys = {
      { "<leader>qs", function() require("persistence").load() end,                desc = "Restore Session" },
      { "<leader>ql", function() require("persistence").load({ last = true }) end, desc = "Restore Last Session" },
      { "<leader>qd", function() require("persistence").stop() end,                desc = "Don't Save Current Session" },
    },
  },

  -- Resize windows
  {
    'mrjones2014/smart-splits.nvim',
    event = 'BufReadPost',
    opts = {
      -- Ignored filetypes (only while resizing)
      ignored_filetypes = {
        'nofile',
        'quickfix',
        'qf',
        'prompt',
      },
      -- Ignored buffer types (only while resizing)
      ignored_buftypes = { 'nofile' },
    },
    keys = {
      { '<C-Up>', '<cmd>SmartResizeUp<cr>', 'Resize Up' },
      { '<C-Down>', '<cmd>SmartResizeDown<cr>', 'Resize Down' },
      { '<C-Left>', '<cmd>SmartResizeLeft<cr>', 'Resize Left' },
      { '<C-Right>', '<cmd>SmartResizeRight<cr>', 'Resize Right' },
    },
  },

  -- Smooth scroll
  {
    'karb94/neoscroll.nvim',
    event = { 'BufNewFile', 'BufReadPre' },
    enabled = not vim.g.neovide,
    config = function()
      require('neoscroll').setup {
        mappings = { '<C-u>', '<C-d>', '<C-f>', '<C-b>' },
        hide_cursor = true,
        stop_eof = true,
        respect_scrolloff = false,
        cursor_scrolls_alone = true,
        easing_function = nil,
        pre_hook = nil,
        post_hook = nil,
        performance_mode = false,
      }
    end,
  },

  -- Open URL under the cursor
  {
    'chrishrb/gx.nvim',
    event = { 'BufNewFile', 'BufReadPre' },
    dependencies = { 'nvim-lua/plenary.nvim' },
    cmd = { 'Browse' },
    keys = { { 'gx', '<cmd>Browse<cr>', mode = { 'n', 'x' } } },
    init = function()
      vim.g.netrw_nogx = 1 -- disable netrw gx
    end,
    config = function()
      require('gx').setup {
        -- `sudo apt install wslu xdg-utils -y`
        open_browser_app = require('util').is_win() and 'powershell.exe' or 'xdg-open',
        -- open_browser_args = { "--background" },
        handlers = {
          plugin = true,
          github = true,
          brewfile = true,
          package_json = true,
          search = true,
        },
        handler_options = {
          search_engine = 'google',
          -- search_engine = "https://search.brave.com/search?q=",
        },
      }
    end,
  },
}
