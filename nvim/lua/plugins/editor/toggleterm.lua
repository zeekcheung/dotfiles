return {
  "akinsho/toggleterm.nvim",
  cmd = "ToggleTerm",
  config = true,
  opts = {
    open_mapping = [[<c-\]],
    size = 10,
    autochdir = true, -- when neovim changes it current directory the terminal will change it's own when next it's opened
    shading_factor = 2,
    direction = "float",
    float_opts = {
      border = "curved",
      highlights = { border = "Normal", background = "Normal" },
    },
  },
  keys = function()
    return {
      { "<leader>t", desc = "Terminal" },
      { "<leader>tf", "<cmd>ToggleTerm direction=float<cr>", desc = "ToggleTerm float" },
      { "<leader>th", "<cmd>ToggleTerm size=10 direction=horizontal<cr>", desc = "ToggleTerm horizontal" },
      { "<leader>tv", "<cmd>ToggleTerm size=80 direction=vertical<cr>", desc = "ToggleTerm vertical" },
      -- escape terminal mode
      { mode = "t", "<esc>", [[<C-\><C-n>]], { desc = "Escape Terminal Mode" }, nowait = true },
    }
  end,
}
