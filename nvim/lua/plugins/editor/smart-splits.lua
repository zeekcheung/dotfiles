return {
  "mrjones2014/smart-splits.nvim",
  event = "BufReadPost",
  keys = {
    { "<C-Up>", "<cmd>SmartResizeUp<cr>", "Resize Up" },
    { "<C-Down>", "<cmd>SmartResizeDown<cr>", "Resize Down" },
    { "<C-Left>", "<cmd>SmartResizeLeft<cr>", "Resize Left" },
    { "<C-Right>", "<cmd>SmartResizeRight<cr>", "Resize Right" },
  },
  opts = {
    -- Ignored filetypes (only while resizing)
    ignored_filetypes = {
      "nofile",
      "quickfix",
      "qf",
      "prompt",
    },
    -- Ignored buffer types (only while resizing)
    ignored_buftypes = { "nofile" },
  },
}
