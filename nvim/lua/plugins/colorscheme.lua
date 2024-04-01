return {

  {
    'catppuccin/nvim',
    lazy = false,
    priority = 1000,
    name = 'catppuccin',
    opts = {
      no_bold = true,
      transparent_background = vim.g.transparent_background,
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
            CmpBorder = { fg = "#4e4d5d" },
            CmpDocBorder = { link = "CmpBorder" },
            -- CmpItemMenu = { bg = "#181825" },
            Pmenu = { fg = '', bg = "#2d2c3c" },
            PmenuSel = { fg = "#abe9b3", bg = "#1e1d2d" },
            HoverBorder = { link = "CmpBorder" },
            SignatureHelpBorder = { link = "CmpBorder" },
          }
        end,
      },
    },
  },

  {
    'folke/tokyonight.nvim',
    enabled = false,
    lazy = false,
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

  {
    'rose-pine/neovim',
    enabled = false,
    lazy = false,
    priority = 1000,
    name = 'rose-pine',
    opts = {
      highlight_groups = {
        -- statusline
        StatusLine = { fg = 'love', bg = 'love', blend = 10 },
        StatusLineNC = { fg = 'subtle', bg = 'surface' },

        -- transparent telescope
        TelescopeBorder = { fg = 'highlight_high', bg = 'none' },
        TelescopeNormal = { bg = 'none' },
        TelescopePromptNormal = { bg = 'base' },
        TelescopeResultsNormal = { fg = 'subtle', bg = 'none' },
        TelescopeSelection = { fg = 'text', bg = 'base' },
        TelescopeSelectionCaret = { fg = 'rose', bg = 'rose' },
      },
    },
  },
}
