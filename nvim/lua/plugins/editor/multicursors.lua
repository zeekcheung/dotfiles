return {
  "smoka7/multicursors.nvim",
  dependencies = {
    "smoka7/hydra.nvim",
  },
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
  opts = {},
}
