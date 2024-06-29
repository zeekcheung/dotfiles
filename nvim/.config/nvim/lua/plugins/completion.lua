local border_with_highlight = require('util.highlight').border_with_highlight

return {
  -- Completion
  {
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'saadparwaiz1/cmp_luasnip',
    },
    opts = function()
      local has_words_before = function()
        unpack = unpack or table.unpack
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match '%s' == nil
      end

      local cmp = require 'cmp'
      local luasnip = require 'luasnip'
      local defaults = require 'cmp.config.default'()

      return {
        completion = { completeopt = 'menu,menuone,noinsert' },
        snippet = {
          expand = function(args)
            require('luasnip').lsp_expand(args.body)
          end,
        },
        sources = {
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'buffer' },
          { name = 'path' },
        },
        window = {
          completion = {
            side_padding = 1,
            -- border = vim.g.cmp_border,
            border = border_with_highlight 'CmpBorder',
            winhighlight = 'Normal:CmpPmenu,CursorLine:PmenuSel,Search:None',
            scrollbar = false,
          },
          documentation = {
            border = border_with_highlight 'CmpDocBorder',
            winhighlight = 'Normal:CmpDoc',
          },
          -- documentation = cmp.config.disable,
        },
        mapping = cmp.mapping.preset.insert {
          ['<C-n>'] = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Insert },
          ['<C-p>'] = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Insert },
          ['<C-j>'] = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Insert },
          ['<C-k>'] = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Insert },
          ['<CR>'] = cmp.mapping.confirm { select = false },
          ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              -- You could replace select_next_item() with confirm({ select = true }) to get VS Code autocompletion behavior
              cmp.select_next_item()
              -- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable()
              -- this way you will only jump inside the snippet region
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            elseif has_words_before() then
              cmp.complete()
            else
              fallback()
            end
          end, { 'i', 's' }),
          ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { 'i', 's' }),
        },
        experimental = {
          ghost_text = {
            hg_group = 'CmpGhostText',
          },
        },
        sorting = defaults.sorting,
        performance = {
          fetching_timeout = 0,
          confirm_resolve_timeout = 0,
          max_view_entries = 7,
        },
        formatting = {
          format = function(_, item)
            local icons = require('util.icons').kinds
            if icons[item.kind] then
              item.kind = icons[item.kind] .. item.kind
            end
            return item
          end,
        },
      }
    end,
    config = function(_, opts)
      local cmp = require 'cmp'
      cmp.setup(opts)

      -- insert `(` after select function or method item
      cmp.event:on('confirm_done', function(event)
        local entry = event.entry
        local item = entry:get_completion_item()

        if item.kind == cmp.lsp.CompletionItemKind.Function or item.kind == cmp.lsp.CompletionItemKind.Method then
          vim.api.nvim_put({ '()' }, 'c', true, false)
        end
      end)
    end,
  },

  -- Snippets
  {
    'L3MON4D3/LuaSnip',
    -- enabled = vim.fn.has 'nvim-0.10' ~= 1,
    event = 'InsertEnter',
    ---@diagnostic disable-next-line: undefined-global
    build = (not jit.os:find 'Windows')
        and "echo 'NOTE: jsregexp is optional, so not a big deal if it fails to build'; make install_jsregexp"
      or nil,
    dependencies = {
      'rafamadriz/friendly-snippets',
      event = 'InsertEnter',
      config = function()
        require('luasnip.loaders.from_vscode').lazy_load()
      end,
    },
    opts = {
      history = true,
      delete_check_events = 'TextChanged',
    },
  },

  -- Command line completion
  {
    'hrsh7th/cmp-cmdline',
    event = 'CmdlineEnter',
    dependencies = { 'hrsh7th/nvim-cmp' },
    config = function()
      local cmp = require 'cmp'

      -- `/` cmdline setup.
      cmp.setup.cmdline('/', {
        completion = {
          completeopt = 'menu,menuone,noselect',
        },
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = 'buffer' },
        },
      })

      -- `:` cmdline setup.
      cmp.setup.cmdline(':', {
        completion = {
          completeopt = 'menu,menuone,noselect',
        },
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = 'path' },
        }, {
          {
            name = 'cmdline',
            option = {
              ignore_cmds = { 'Man', '!' },
            },
          },
        }),
      })
    end,
  },

  -- Codeium
  {
    'Exafunction/codeium.vim',
    enabled = true,
    event = 'VeryLazy',
    dependencies = {
      {
        'nvim-cmp',
        opts = function(_, opts)
          opts.experimental.ghost_text = false
        end,
      },
    },
    config = function()
      vim.keymap.set('i', '<C-f>', function()
        return vim.fn['codeium#Accept']()
      end, { expr = true, silent = true })
      vim.keymap.set('i', '<c-.>', function()
        return vim.fn['codeium#CycleCompletions'](1)
      end, { expr = true, silent = true })
      vim.keymap.set('i', '<c-,>', function()
        return vim.fn['codeium#CycleCompletions'](-1)
      end, { expr = true, silent = true })
      vim.keymap.set('i', '<c-l>', function()
        return vim.fn['codeium#Clear']()
      end, { expr = true, silent = true })
    end,
  },

  {
    'Exafunction/codeium.nvim',
    enabled = false,
    event = 'VeryLazy',
    cmd = 'Codeium',
    opts = {
      enable_chat = true,
    },
    dependencies = {
      {
        'nvim-cmp',
        opts = function(_, opts)
          opts.experimental.ghost_text = false
          table.insert(opts.sources, 1, {
            name = 'codeium',
            group_index = 1,
            priority = 100,
          })
        end,
      },
    },
  },

  -- Supermaven
  {
    'supermaven-inc/supermaven-nvim',
    enabled = false,
    event = 'VeryLazy',
    dependencies = {
      {
        'nvim-cmp',
        opts = function(_, opts)
          opts.experimental.ghost_text = false
          -- table.insert(opts.sources, 1, {
          --   name = 'supermaven',
          --   group_index = 1,
          --   priority = 100,
          -- })
        end,
      },
    },
    opts = {
      keymaps = {
        accept_suggestion = '<C-f>',
        accept_word = '<A-f>',
        clear_suggestion = '<C-l>',
      },
      -- disable_inline_completion = true,
    },
  },
}
