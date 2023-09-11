return {
  "petertriho/nvim-scrollbar",
  event = "VeryLazy",
  opts = function(_, opts)
    local utils = require("utils")

    utils.extend_tbl(opts, {
      handlers = {
        gitsigns = utils.is_available("gitsigns.nvim"),
        search = utils.is_available("nvim-hlslens"),
        ale = utils.is_available("ale"),
      },
    })
  end,
}
