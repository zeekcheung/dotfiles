return {
  "akinsho/bufferline.nvim",
  event = { "BufReadPost", "BufNewFile" },
  opts = {
    options = {
      -- stylua: ignore
      close_command = function(n) require("mini.bufremove").delete(n, false) end,
      -- stylua: ignore
      right_mouse_command = function(n) require("mini.bufremove").delete(n, false) end,
      diagnostics = "nvim_lsp",
      always_show_bufferline = true,
      separator_style = "slant",
      -- indicator = { style = "underline" },
      offsets = {
        {
          filetype = "neo-tree",
          text = "EXPLORER",
          highlight = "Directory",
          text_align = "center",
        },
      },
    },
  },
  keys = {
    { "<leader>bp", "<Cmd>BufferLinePick<CR>", desc = "Pick buffer" },
    { "<leader>bP", "<Cmd>BufferLineTogglePin<CR>", desc = "Toggle pin buffer" },
    { "<leader>bl", "<Cmd>BufferLineCloseLeft<CR>", desc = "Close all buffers to the left" },
    { "<leader>br", "<Cmd>BufferLineCloseRight<CR>", desc = "Close all buffers to the right" },
    { "<leader>bC", "<Cmd>BufferLineGroupClose<CR>", desc = "Close all buffers" },
    { "<leader>bc", "<Cmd>BufferLineCloseOthers<CR>", desc = "Close all buffers except current" },
    { "<leader>bs", desc = "Sort" },
    { "<leader>bse", "<Cmd>BufferLineSortByExtension<CR>", desc = "Sort by extension" },
    { "<leader>bsn", "<Cmd>BufferLineSortByTabs<CR>", desc = "Sort by number" },
    { "<leader>bsp", "<Cmd>BufferLineSortByDirectory<CR>", desc = "Sort by full path" },
    { "<leader>bsr", "<Cmd>BufferLineSortByRelativeDirectory<CR>", desc = "Sort by relative path" },
  },
}
