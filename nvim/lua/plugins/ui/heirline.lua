return {
  "rebelot/heirline.nvim",
  event = "VeryLazy",
  enabled = false,
  config = function()
    local colors = require("utils.colors")
    local statusline = require("utils.status.statusline")
    local tabline = require("utils.status.tabline")
    local conditions = require("heirline.conditions")

    local heirline = require("heirline")

    -- TODO: Replace statusline/bufferline/statuscolumn with heirline
    heirline.statusline = statusline
    --[[ heirline.statuscolumn = { -- statuscolumn
    } ]]

    heirline.tabline = tabline

    --[[ heirline.winbar = { -- winbar
    } ]]
  end,
}
