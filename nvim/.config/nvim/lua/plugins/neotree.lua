local icons = require 'util.icons'

return {
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
}
