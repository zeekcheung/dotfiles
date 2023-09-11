return {
  "chentoast/marks.nvim",
  event = "VeryLazy",
  opts = {
    excluded_filetypes = {
      "qf",
      "NvimTree",
      "toggleterm",
      "TelescopePrompt",
      "alpha",
      "netrw",
      "neo-tree",
    },
    mappings = {
      toggle = "mt",
      set_next = "ma",
      delete = "md",
      delete_bookmark = "mdc",
      delete_line = "mdl",
      delete_buf = "mdb",
      prev = "mdm[",
      next = "m]",
      preview = "mp",
      annotate = "mc",
    },
  },
}
