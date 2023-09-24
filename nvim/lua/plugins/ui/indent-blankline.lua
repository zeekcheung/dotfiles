return {
  "lukas-reineke/indent-blankline.nvim",
  event = { "BufReadPost", "BufNewFile" },
  opts = {
    -- char = "▏",
    char = "│",
    show_trailing_blankline_indent = false,
    show_current_context = false,
    filetype_exclude = {
      "help",
      "alpha",
      "aerial",
      "dashboard",
      "neo-tree",
      "Trouble",
      "lazy",
      "mason",
      "notify",
      "toggleterm",
      "lazyterm",
    },
    buftype_exclude = {
      "terminal",
      "nofile",
    },
  },
  config = function()
    local augroup = vim.api.nvim_create_augroup("indent_blankline", { clear = true })
    local autocmd = vim.api.nvim_create_autocmd

    -- HACK: indent blankline doesn't properly refresh when scrolling the window
    -- remove when fixed upstream: https://github.com/lukas-reineke/indent-blankline.nvim/issues/489
    autocmd("WinScrolled", {
      desc = "Refresh indent blankline on window scroll",
      group = augroup,
      callback = function()
        if vim.fn.has("nvim-0.9") ~= 1 then
          pcall(vim.cmd.IndentBlanklineRefresh)
        end
      end,
    })
  end,
}
