return {
  "s1n7ax/nvim-window-picker",
  name = "window-picker",
  event = { "BufReadPost", "BufNewFile" },
  version = "2.*",
  config = function()
    require("window-picker").setup()
  end,
}
