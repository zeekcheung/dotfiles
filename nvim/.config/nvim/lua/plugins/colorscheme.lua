return {
  {
    'rose-pine/neovim',
    -- cond = string.find(vim.g.colorscheme, 'rose-pine', 1, true) ~= nil,
    lazy = false,
    priority = 1000,
    name = 'rose-pine',
    opts = {
      dark_variant = 'moon',
      dim_inactive_windows = false,
      styles = {
        bold = false,
        transparency = vim.g.transparent_background,
      },
      highlight_groups = {
        -- statusline
        StatusLine = { fg = 'rose', bg = 'love', blend = vim.g.transparent_background and 0 or 10 },
        StatusLineNC = { fg = 'subtle', bg = 'surface' },
        StatusLineNormal = { fg = 'black', bg = 'rose', bold = true },
        StatusLineInsert = { fg = 'black', bg = 'foam', bold = true },
        StatusLineVisual = { fg = 'black', bg = 'iris', bold = true },
        StatusLineReplace = { fg = 'black', bg = 'pine', bold = true },
        StatusLineCommand = { fg = 'black', bg = 'love', bold = true },
        StatusLineTerminal = { fg = 'black', bg = 'gold', bold = true },

        -- transparent telescope
        TelescopeBorder = { fg = 'highlight_high', bg = 'none' },
        TelescopeNormal = { bg = 'none' },
        TelescopePromptNormal = { bg = 'base' },
        TelescopeResultsNormal = { fg = 'text' },
        TelescopeSelection = { fg = 'text', bg = '#393552' },
        -- TelescopeSelectionCaret = { fg = 'rose', bg = 'rose' },

        -- CmpItemMenu = { bg = "#181825" },
        CmpBorder = { fg = '#4e4d5d' },
        CmpDocBorder = { link = 'CmpBorder' },
        HoverBorder = { link = 'CmpBorder' },
        SignatureHelpBorder = { link = 'CmpBorder' },
      },
    },
  },
}
