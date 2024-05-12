-- NOTE:
-- Find more plugins here: https://neovimcraft.com/

local Util = require 'util'
local Ui = require 'util.ui'

local map = Util.silent_map
local icons = Ui.icons

return {
  -- Library used by other plugins
  { 'MunifTanjim/nui.nvim', lazy = true },
  { 'nvim-lua/plenary.nvim', lazy = true },
  { 'nvim-tree/nvim-web-devicons', lazy = true },

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
        ---@diagnostic disable-next-line: param-type-mismatch
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
      enable_diagnostics = false,
      sources = { 'filesystem', 'buffers', 'git_status', 'document_symbols' },
      source_selector = {
        winbar = false,
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
            added = '',
            deleted = '',
            modified = '',
            renamed = '',
            untracked = '',
            ignored = '',
            unstaged = '',
            staged = '',
            conflict = '',
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
          ['<leftrelease>'] = 'toggle_node',
          ['za'] = 'toggle_node',
          ['O'] = {
            function(state)
              require('lazy.util').open(state.tree:get_node().path, { system = true })
            end,
            desc = 'Open with System Application',
          },
          ['P'] = {
            'toggle_preview',
            config = { use_float = true, use_image_nvim = true },
          },
        },
      },
      filesystem = {
        bind_to_cwd = false,
        follow_current_file = { enabled = true },
        use_libuv_file_watcher = true,
        filtered_items = {
          visible = false,
          show_hidden_count = true,
          hide_dotfiles = true,
          hide_gitignored = true,
          hide_by_name = {},
          always_show = {
            '.config',
            '.local',
            '.bashrc',
            '.bash_profile',
            '.tmux.conf',
            '.vimrc',
            '.zshenv',
            '.zshrc',
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
            -- hide statuscolumn in neo-tree
            vim.opt.statuscolumn = ''
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
        opts = { manual_mode = false },
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
          path_display = {
            filename_first = {
              reverse_directories = false,
            },
          },
          sorting_strategy = 'ascending',
          layout_config = {
            horizontal = { prompt_position = 'top', preview_width = 0.55 },
            vertical = { mirror = false },
            width = 0.87,
            height = 0.80,
            -- preview_cutoff = 0, -- always show file preview
          },
          mappings = {
            n = {
              ['q'] = actions.close,
              ['<Tab>'] = {
                actions.move_selection_next,
                type = 'action',
                opts = { nowait = true, silent = true },
              },
              ['<S-Tab>'] = {
                actions.move_selection_previous,
                type = 'action',
                opts = { nowait = true, silent = true },
              },
            },
            i = {
              ['<Tab>'] = {
                actions.move_selection_next,
                type = 'action',
                opts = { nowait = true, silent = true },
              },
              ['<S-Tab>'] = {
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
        {
          '<leader><leader>',
          '<cmd>Telescope buffers sort_mru=true sort_lastused=true<cr>',
          desc = 'Switch Buffer',
        },
        { '<leader>/',  builtin.live_grep,    desc = 'Find Words' },
        { '<leader>fa', builtin.autocommands, desc = 'Autocmds' },
        { '<leader>fb', builtin.buffers,      desc = 'Buffers' },
        {
          '<leader>fc',
          function() builtin.find_files { cwd = vim.fn.stdpath 'config' } end,
          desc = 'Config',
        },
        {
          '<leader>fd',
          function() builtin.diagnostics { bufnr = 0 } end,
          desc = 'Diagnostics',
        },
        { '<leader>fD', builtin.diagnostics, desc = 'Workspace diagnostics' },
        { '<leader>ff', builtin.find_files,  desc = 'Files' },
        {
          '<leader>fF',
          function()
            builtin.find_files({ find_command = { 'rg', '--files', '--hidden', '-g', '!.git' } })
          end,
          desc = 'All files',
        },
        { '<C-p>',      '<leader>fF',         desc = 'All files',   remap = true },
        { '<leader>fh', builtin.help_tags,    desc = 'Help Pages' },
        { '<leader>fk', builtin.keymaps,      desc = 'Key Maps' },
        { '<leader>fo', builtin.oldfiles,     desc = 'Recent Files' },
        { '<leader>fr', builtin.registers,    desc = 'Registers' },
        { '<leader>fw', builtin.live_grep,    desc = 'Words' },
        { '<leader>gb', builtin.git_branches, desc = 'Git Branches' },
        { '<leader>gc', builtin.git_commits,  desc = 'Git commits' },
        { '<leader>gf', builtin.git_files,    desc = 'Git files' },
        { '<leader>gs', builtin.git_stash,    desc = 'Git statsh' },
        { '<leader>gt', builtin.git_status,   desc = 'Git status' },
        {
          '<leader>uc',
          function() builtin.colorscheme { enable_preview = true } end,
          desc = 'Colorscheme',
        },
      }
    end,
  },

  -- Terminal
  {
    'akinsho/toggleterm.nvim',
    version = '*',
    event = 'VeryLazy',
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

          vim.wo.statuscolumn = ''

          -- close terminal window and exit running progress
          map('n', 'q', '<cmd>bd!<CR>', { buffer = bufnr, noremap = true, silent = true })

          if direction ~= 'float' then
            ---@diagnostic disable-next-line: redefined-local
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
          on_close = function()
            vim.cmd 'startinsert!'
          end,
        }

        function ToggleLazygit()
          lazygit.cmd = 'cd ' .. vim.fn.getcwd() .. ' && lazygit'
          lazygit:toggle()
        end

        map('n', '<leader>gg', '<cmd>lua ToggleLazygit()<CR>', { desc = 'lazygit' })
      end

      map('t', '<esc>', [[<C-\><C-n>]])
      map('n', '<leader>tf', '<cmd>ToggleTerm direction=float<cr>', { desc = 'ToggleTerm float' })
      -- stylua: ignore
      map('n', '<leader>th', '<cmd>ToggleTerm size=' .. newterm_opts['horizontal'].size .. ' direction=horizontal<cr>',
        { desc = 'ToggleTerm horizontal split' })
      -- stylua: ignore
      map('n', '<leader>tv', '<cmd>ToggleTerm size=' .. newterm_opts['vertical'].size .. ' direction=vertical<cr>',
        { desc = 'ToggleTerm vertical split' })
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

  -- Open URL under the cursor
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

  -- Image preview
  {
    '3rd/image.nvim',
    event = 'VeryLazy',
    enabled = false,
    dependencies = {
      {
        'vhyrro/luarocks.nvim',
        priority = 1000,
        opts = {
          rocks = { 'magick' },
        },
      },
    },
    opts = {
      -- backend = (string.find(vim.env.TERM, 'kitty', 1, true) ~= nil
      --     or string.find(vim.env.TERM, 'wezterm', 1, true) ~= nil)
      --   and 'kitty' or 'ueberzug',
      editor_only_render_when_focused = true,
      tmux_show_only_in_active_window = true,
    },
  },
}
