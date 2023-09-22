return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    plugins = { spelling = true },
    ---------------------------------------
    -- 1. Set root keymaps in which-key
    -- 2. Set sub keymaps in other plugins or keymaps.lua
    ---------------------------------------
    defaults = {
      mode = { "n", "v" },
      ["g"] = { name = "goto" },
      ["gz"] = { name = "surround" },
      ["gl"] = { name = "Goto Line" },
      ["]"] = { name = "next" },
      ["["] = { name = "prev" },
      ["<leader>b"] = { name = "Buffer" },
      ["<leader>f"] = { name = "Find" },
      ["<leader>g"] = { name = "Git" },
      ["<leader>l"] = { name = "Lsp" },
      ["<leader>p"] = { name = "Plugins" },
      ["<leader>n"] = { name = "Null-ls" },
      ["<leader>q"] = { name = "Quit" },
      ["<leader>s"] = { name = "Session" },
      ["<leader>t"] = { name = "Terminal" },
      ["<leader>u"] = { name = "UI" },
    },
  },
  config = function(_, opts)
    local wk = require("which-key")
    wk.setup(opts)
    wk.register(opts.defaults)
  end,
}
