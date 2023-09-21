return {
  "mrjones2014/smart-splits.nvim",
  event = "BufReadPost",
  keys = function()
    local smart_splits = require("smart-splits")
    -- stylua: ignore
    return {
      { "<C-Up>", function() smart_splits.resize_up() end, "Resize Up" },
      { "<C-Down>", function() smart_splits.resize_down() end, "Resize Down" },
      { "<C-Left>", function() smart_splits.resize_left() end, "Resize Left" },
      { "<C-Right>", function() smart_splits.resize_right() end, "Resize Right" },
    }
  end,
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
