return {
  "rcarriga/nvim-notify",
  keys = {
    {
      "<leader>un",
      function()
        require("notify").dismiss({ silent = true, pending = true })
      end,
      desc = "Dismiss all Notifications",
    },
  },
  opts = {
    timeout = 2000,
    stages = "slide",
    top_down = false,
    max_height = function()
      return math.floor(vim.o.lines * 0.75)
    end,
    max_width = function()
      return math.floor(vim.o.columns * 0.75)
    end,
  },
  init = function()
    -- when noice is not enabled, install notify on VeryLazy
    local utils = require("utils")
    if not utils.is_available("noice.nvim") then
      utils.on_very_lazy(function()
        vim.notify = require("notify")
      end)
    end
  end,
}
