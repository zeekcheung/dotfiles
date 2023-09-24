return {
  {
    "folke/tokyonight.nvim",
    lazy = false,
    enabled = false,
    opts = { style = "night" },
    config = function()
      vim.cmd("colorscheme tokyonight-night")
    end,
  },
  {
    "rose-pine/neovim",
    name = "rose-pine",
    lazy = false,
    enabled = true,
    opts = {},
    config = function()
      vim.cmd("colorscheme rose-pine-moon")
    end,
  },
}
