return {
  -- Fuzzy finder
  {
    'nvim-telescope/telescope.nvim',
    cmd = 'Telescope',
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
          find_files = {
            follow = true,
          },
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
        { '<leader>fc', require("util").find_configs, desc = 'Config' },
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
        {'<C-p>',      '<leader>fF',         desc = 'All files',   remap = true },
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
}
