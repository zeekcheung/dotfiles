return {
  { "Bekaboo/dropbar.nvim", event = "UIEnter", opts = {} },
  {
    "catppuccin/nvim",
    optional = true,
    opts = { integrations = { dropbar = { enabled = true } } },
  },
}
