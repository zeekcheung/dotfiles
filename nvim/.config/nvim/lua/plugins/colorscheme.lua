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
    },
  },
}
