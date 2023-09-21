return {
  "smoka7/multicursors.nvim",
  cmd = { "MCstart", "MCvisual", "MCclear", "MCpattern", "MCvisualPattern", "MCunderCursor" },
  keys = {
    {
      mode = { "v", "n" },
      "<Leader>m",
      ":MCstart<cr>",
      desc = "Start multicursor",
    },
  },
  event = { "BufReadPost", "BufNewFile" },
  dependencies = {
    "smoka7/hydra.nvim",
  },
  opts = {},
}
