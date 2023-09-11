return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    plugins = { spelling = true },
    defaults = {
      mode = { "n", "v" },
      ["g"] = { name = "goto" },
      ["gs"] = { name = "surround" },
      ["]"] = { name = "next" },
      ["["] = { name = "prev" },
      -- ["<leader><tab>"] = { name = "Tabs" },
      ["<leader>a"] = { name = "Annotation" },
      ["<leader>b"] = { name = "Buffer" },
      ["<leader>bs"] = { name = "Sort" },
      ["<leader>c"] = { name = "Close buffer" },
      ["<leader>f"] = { name = "Find" },
      ["<leader>g"] = { name = "Git" },
      ["<leader>gh"] = { name = "hunks" },
      ["<leader>l"] = { name = "LSP" },
      ["<leader>L"] = { name = "LazyVim" },
      ["<leader>n"] = { name = "Noice" },
      ["<leader>p"] = { name = "Packages" },
      ["<leader>q"] = { name = "Quit" },
      ["<leader>s"] = { name = "Session" },
      ["<leader>t"] = { name = "Termial" },
      ["<leader>T"] = { name = "Todo/Trouble" },
      ["<leader>u"] = { name = "UI" },
      ["<leader>w"] = { name = "Save" },
    },
  },
  config = function(_, opts)
    local wk = require("which-key")
    wk.setup(opts)
    wk.register(opts.defaults)
  end,
}
