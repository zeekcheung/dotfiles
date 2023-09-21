return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    plugins = { spelling = true },
    defaults = {
      mode = { "n", "v" },
      ["g"] = { name = "goto" },
      ["gz"] = { name = "surround" },
      ["]"] = { name = "next" },
      ["["] = { name = "prev" },
      ["<leader>b"] = { name = "Buffer" },
      ["<leader>f"] = { name = "Find" },
      ["<leader>g"] = { name = "Git" },
      ["<leader>u"] = { name = "UI" },
    },
  },
  config = function(_, opts)
    local wk = require("which-key")

    wk.setup(opts)
    wk.register(opts.defaults)

    -- quit
    wk.register({
      mode = { "n", "v", "x" },
      ["<leader>q"] = { name = "quit" },
      ["<leader>qq"] = { ":qa<cr>", "Quit All" },
      ["<leader>qw"] = { ":exit<cr>", "Quit current window" },
    })

    -- goto line
    wk.register({
      mode = { "n", "v", "x" },
      ["gl"] = { name = "goto line" },
      ["gls"] = { "^", "Goto line start" },
      ["gle"] = { "$", "Goto line end" },
    })

    -- Lazy
    wk.register({
      ["<leader>L"] = { ":Lazy<cr>", "Lazy" },
    })
  end,
}
