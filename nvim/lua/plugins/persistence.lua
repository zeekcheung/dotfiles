return {
  "folke/persistence.nvim",
  event = "BufReadPre",
  opts = { options = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp" } },
  -- stylua: ignore
  keys = {
    { "<leader>sf", function() require("persistence").load() end, desc = "Find a session" },
    { "<leader>sl", function() require("persistence").load({ last = true }) end, desc = "Restore last session" },
    { "<leader>sd", function() require("persistence").stop() end, desc = "Don't save current session" },
  },
}
