local icons = require 'util.icons'

return {
  -- File explorer
  {
    'nvim-neo-tree/neo-tree.nvim',
    branch = 'v3.x',
    cmd = 'Neotree',
    keys = {
      { '<leader>e', '<cmd>Neotree toggle<cr>', desc = 'Explorer' },
    },
    init = function()
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1

      vim.api.nvim_create_autocmd('BufEnter', {
        group = vim.api.nvim_create_augroup('Neotree_start_directory', { clear = true }),
        desc = 'Start Neo-tree with directory',
        once = true,
        callback = function()
          if package.loaded['neo-tree'] then
            return
          else
            ---@diagnostic disable-next-line: undefined-field
            local stats = vim.uv.fs_stat(vim.fn.argv(0))
            if stats and stats.type == 'directory' then
              require 'neo-tree'
            end
          end
        end,
      })
    end,
    deactivate = function()
      vim.cmd [[Neotree close]]
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
        bind_to_cwd = true,
        follow_current_file = { enabled = false },
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
            vim.opt_local.signcolumn = 'no'
            vim.opt_local.statuscolumn = ''
          end,
        },
      },
    },
  },
}
