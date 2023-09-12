return {
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = true,
    opt = {
      size = 10,
      open_mapping = [[<F7>]],
      direction = "float",
      float_opts = {
        border = "curved",
        highlights = { border = "Normal", background = "Normal" },
      },
    },
  },
}
