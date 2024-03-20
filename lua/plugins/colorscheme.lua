return {

  {
    'catppuccin/nvim',
    priority = 1000,
    name = 'catppuccin',
    opts = {
      no_bold = true,
      -- transparent_background = vim.g.transparent_background,
      integrations = {
        aerial = true,
        cmp = true,
        dashboard = true,
        flash = true,
        gitsigns = true,
        headlines = true,
        illuminate = true,
        indent_blankline = { enabled = true },
        lsp_trouble = true,
        mason = true,
        markdown = true,
        mini = true,
        native_lsp = {
          enabled = true,
          underlines = {
            errors = { 'undercurl' },
            hints = { 'undercurl' },
            warnings = { 'undercurl' },
            information = { 'undercurl' },
          },
        },
        neotree = true,
        noice = true,
        notify = true,
        rainbow_delimiters = true,
        semantic_tokens = true,
        telescope = true,
        treesitter = true,
        treesitter_context = false,
        which_key = true,
      },
      highlight_overrides = {
        all = function(colors)
          return {
            CmpItemMenu = { bg = colors.mantle },
            Pmenu = { bg = colors.mantle, fg = '' },
            PmenuSel = { bg = colors.green, fg = colors.base },
          }
        end,
      },
    },
  },

  {
    'folke/tokyonight.nvim',
    priority = 1000,
    opts = {
      transparent = vim.g.transparent_background,
      on_highlights = function(hl, colors)
        hl.NeoTreeTitleBar = { fg = '#000000', bg = '#7fbbb3' }
        hl.TelescopeBorder = { fg = '#555555', bg = 'none' }
        hl.TelescopeNormal = { bg = 'none' }
        hl.TelescopeResultsNormal = { bg = 'none' }
        hl.TelescopeSelection = { bg = 'none' }
        hl.TelescopeSelectionCaret = { bg = 'none' }
      end,
    },
  },
}
