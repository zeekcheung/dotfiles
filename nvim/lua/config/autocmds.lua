local utils = require("utils")

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Highlight on yank
autocmd("TextYankPost", {
  desc = "Highlight on yank",
  group = augroup("highlight_yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Highlight URL
autocmd({ "VimEnter", "FileType", "BufEnter", "WinEnter" }, {
  desc = "Highlight URL",
  group = augroup("highlight_url", { clear = true }),
  callback = function()
    utils.set_url_match()
  end,
})

-- Resize splits if window got resized
autocmd("VimResized", {
  desc = "Resize splits if window got resized",
  group = augroup("resize_splits", { clear = true }),
  callback = function()
    local current_tab = vim.fn.tabpagenr()
    vim.cmd("tabdo wincmd =")
    vim.cmd("tabnext " .. current_tab)
  end,
})

-- Go to last location when opening a buffer
autocmd("BufReadPost", {
  desc = "Go to last location when opening a buffer",
  group = augroup("last_location", { clear = true }),
  callback = function()
    local exclude = { "gitcommit" }
    local buf = vim.api.nvim_get_current_buf()
    if vim.tbl_contains(exclude, vim.bo.filetype) then
      return
    end
    local mark = vim.api.nvim_buf_get_mark(buf, '"')
    local lcount = vim.api.nvim_buf_line_count(buf)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Wrap and check for spell in text filetypes
autocmd("FileType", {
  group = augroup("wrap_and_check_spell", { clear = true }),
  pattern = {
    "gitcommit",
    "markdown",
  },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})

-- Auto create dir when saving a file, in case some intermediate directories do not exist
autocmd("BufWritePre", {
  group = augroup("auto_create_dir", { clear = true }),
  callback = function(event)
    if event.match:match("^%w%w+://") then
      return
    end
    local file = vim.loop.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
})

-- Start Alpha when nvim is opened with no arguments
if utils.is_available("alpha-nvim") then
  autocmd("VimEnter", {
    desc = "Start Alpha when vim is opened with no arguments",
    group = augroup("alpha_autostart", { clear = true }),
    callback = function()
      local should_skip
      local lines = vim.api.nvim_buf_get_lines(0, 0, 2, false)
      if
        vim.fn.argc() > 0 -- don't start when opening a file
        or #lines > 1 -- don't open if current buffer has more than 1 line
        or (#lines == 1 and lines[1]:len() > 0) -- don't open the current buffer if it has anything on the first line
        or #vim.tbl_filter(function(bufnr)
            return vim.bo[bufnr].buflisted
          end, vim.api.nvim_list_bufs())
          > 1 -- don't open if any listed buffers
        or not vim.o.modifiable -- don't open if not modifiable
      then
        should_skip = true
      else
        for _, arg in pairs(vim.v.argv) do
          if arg == "-b" or arg == "-c" or vim.startswith(arg, "+") or arg == "-S" then
            should_skip = true
            break
          end
        end
      end
      if should_skip then
        return
      end
      require("alpha").start(true, require("alpha").default_config)
      vim.schedule(function()
        vim.cmd.doautocmd("FileType")
      end)
    end,
  })
end

-- Use Powershell as default shell on Windows
autocmd("VimEnter", {
  group = augroup("use_powershell_shell", { clear = true }),
  callback = function()
    local os_type = vim.loop.os_uname().sysname
    if string.match(os_type, "Windows") then
      vim.opt.shell = "pwsh -nologo"
      vim.opt.shellredir = "-RedirectStandardOutput %s -NoNewWindow -Wait"
      vim.opt.shellpipe = "2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode"
      vim.opt.shellquote = ""
      vim.opt.shellxquote = ""
    end
  end,
})

-- HACK: indent blankline doesn't properly refresh when scrolling the window
-- remove when fixed upstream: https://github.com/lukas-reineke/indent-blankline.nvim/issues/489
autocmd("WinScrolled", {
  desc = "Refresh indent blankline on window scroll",
  group = augroup("indent_blankline_refresh", { clear = true }),
  callback = function()
    if vim.fn.has("nvim-0.9") ~= 1 then
      pcall(vim.cmd.IndentBlanklineRefresh)
    end
  end,
})

-- Increase numberwidth for buffers
autocmd("BufEnter", {
  desc = "Increase numberwidth for buffers",
  group = augroup("increase_numberwidth", { clear = true }),
  callback = function()
    local line_count = vim.api.nvim_buf_line_count(0)
    if line_count >= 100 and line_count < 1000 then
      vim.opt_local.numberwidth = 5
    elseif line_count > 1000 and line_count < 10000 then
      vim.opt_local.numberwidth = 6
    elseif line_count >= 10000 then
      vim.opt_local.numberwidth = 7
    end
  end,
})

-- close some filetypes with <q>
autocmd("FileType", {
  group = augroup("close_with_q", { clear = true }),
  pattern = {
    "PlenaryTestPopup",
    "help",
    "lspinfo",
    "man",
    "notify",
    "qf",
    "spectre_panel",
    "startuptime",
    "tsplayground",
    "neotest-output",
    "checkhealth",
    "neotest-summary",
    "neotest-output-panel",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
  end,
})

-- HACK: indent blankline doesn't properly refresh when scrolling the window
-- remove when fixed upstream: https://github.com/lukas-reineke/indent-blankline.nvim/issues/489
autocmd("WinScrolled", {
  desc = "Refresh indent blankline on window scroll",
  group = augroup("indent_blankline_refresh", { clear = true }),
  callback = function()
    if vim.fn.has("nvim-0.9") ~= 1 then
      pcall(vim.cmd.IndentBlanklineRefresh)
    end
  end,
})
