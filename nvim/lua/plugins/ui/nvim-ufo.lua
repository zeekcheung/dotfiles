return {
  -- UFO folding
  {
    "kevinhwang91/nvim-ufo",
    enabled = true,
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      "kevinhwang91/promise-async",
      "luukvbaal/statuscol.nvim",
    },
    opts = {
      provider_selector = function()
        return { "treesitter", "indent" }
      end,
    },

    init = function()
      local icons = require("utils.icons")

      vim.opt.foldcolumn = "1" -- show foldcolumn in nvim 0.9
      vim.opt.foldenable = true -- enable fold for nvim-ufo
      vim.opt.foldlevel = 99 -- set high foldlevel for nvim-ufo
      vim.opt.foldlevelstart = 99 -- start with all code unfolded
      vim.opt.fillchars = {
        eob = " ",
        fold = " ",
        foldsep = " ",
        foldopen = icons.FoldOpened, -- +
        foldclose = icons.FoldClosed, -- -
      }

      vim.keymap.set("n", "zR", function()
        require("ufo").openAllFolds()
      end)
      vim.keymap.set("n", "zM", function()
        require("ufo").closeAllFolds()
      end)
    end,
  },
  -- Folding preview, by default h and l keys are used.
  -- On first press of h key, when cursor is on a closed fold, the preview will be shown.
  -- On second press the preview will be closed and fold will be opened.
  -- When preview is opened, the l key will close it and open fold. In all other cases these keys will work as usual.
  { "anuvyklack/fold-preview.nvim", dependencies = "anuvyklack/keymap-amend.nvim", config = true },
}
