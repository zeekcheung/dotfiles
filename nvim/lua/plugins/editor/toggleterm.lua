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
    local utils = require("utils")
    local default_keys = {
      { "<leader>t", desc = "Terminal" },
      { "<leader>tf", "<cmd>ToggleTerm direction=float<cr>", desc = "ToggleTerm float" },
      { "<leader>th", "<cmd>ToggleTerm size=10 direction=horizontal<cr>", desc = "ToggleTerm horizontal" },
      { "<leader>tv", "<cmd>ToggleTerm size=80 direction=vertical<cr>", desc = "ToggleTerm vertical" },
      -- escape terminal mode
      { mode = "t", "<esc>", [[<C-\><C-n>]], { desc = "Escape Terminal Mode" }, nowait = true },
    }

    local status_ok, toggleterm_terminal = pcall(require, "toggleterm.terminal")
    if status_ok then
      local Terminal = require("toggleterm.terminal").Terminal
      local lazygit = utils.float_term(Terminal, "lazygit", { dir = "git_dir" })
      local node = utils.float_term(Terminal, "node")
      local python = utils.float_term(Terminal, "python")

      function _lazygit_toggle()
        lazygit:toggle()
      end
      function _node_toggle()
        node:toggle()
      end
      function _python_toggle()
        python:toggle()
      end

      local additional_keys = {
        { "<leader>gg", "<cmd>lua _lazygit_toggle()<cr>", desc = "Lazygit" },
        { "<leader>tn", "<cmd>lua _node_toggle()<cr>", desc = "Node" },
        { "<leader>tp", "<cmd>lua _python_toggle()<cr>", desc = "Python" },
      }

      for _, key in ipairs(additional_keys) do
        table.insert(default_keys, key)
      end
    end

    return default_keys
  end,
}
