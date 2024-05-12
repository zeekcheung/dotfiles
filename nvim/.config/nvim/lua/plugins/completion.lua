local Ui = require 'util.ui'
local icons = Ui.icons
local border_with_highlight = Ui.border_with_highlight

return {

  -- Completion
  {
    'hrsh7th/nvim-cmp',
    version = false, -- last release is way too old
    event = { 'InsertEnter', 'CmdlineEnter' },
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      -- 'hrsh7th/cmp-nvim-lsp-signature-help',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-cmdline',
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

      vim.api.nvim_set_hl(0, 'CmpGhostText', { link = 'Comment', default = true })

      local opts = {
        completion = {
          -- completeopt = "menu,menuone,noselect",
          completeopt = 'menu,menuone,noinsert',
        },
        snippet = {
          expand = function(args)
            require('luasnip').lsp_expand(args.body)
          end,
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
        sources = {
          { name = 'nvim_lsp' },
          -- { name = 'nvim_lsp_signature_help' },
          { name = 'luasnip' },
          { name = 'buffer' },
          { name = 'path' },
        },
        formatting = {
          format = function(_, item)
            local kind_icons = icons.kinds
            if kind_icons[item.kind] then
              item.kind = kind_icons[item.kind] .. item.kind
            end
            return item
          end,
        },
        experimental = {
          ghost_text = not vim.g.codeium_plugin_enabled,
        },
        sorting = defaults.sorting,
        performance = {
          fetching_timeout = 0,
          confirm_resolve_timeout = 0,
          max_view_entries = 7,
        },
      }

      opts.window = {
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
      }

      return opts
    end,
    config = function(_, opts)
      for _, source in ipairs(opts.sources) do
        source.group_index = source.group_index or 1
      end

      local cmp = require 'cmp'
      cmp.setup(opts)

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

  -- Snippets
  {
    'L3MON4D3/LuaSnip',
    event = 'InsertEnter',
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

  -- Auto pairs
  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    dependencies = { 'hrsh7th/nvim-cmp' },
    opts = {},
    config = function(_, opts)
      require('nvim-autopairs').setup(opts)
      -- Insert `(` after select function or method item
      local cmp_autopairs = require 'nvim-autopairs.completion.cmp'
      local cmp = require 'cmp'
      cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())
    end,
  },
}
