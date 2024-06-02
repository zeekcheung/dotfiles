local draw_my_highlight = require('util.highlight').draw_my_highlight

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Setup colorscheme
autocmd({ 'VimEnter' }, {
  group = augroup('setup_colorscheme', { clear = true }),
  callback = function()
    -- Setup colorscheme
    local success, _ = pcall(function()
      vim.cmd('colorscheme ' .. vim.g.colorscheme)
    end)
    -- Setup fallback colorscheme
    if not success then
      vim.cmd('colorscheme ' .. vim.g.fallback_colorscheme)
    end

    -- Setup custom highlight group
    draw_my_highlight()
  end,
})

-- Draw my highlight on colorscheme change
autocmd({ 'ColorScheme' }, {
  group = augroup('draw_my_highlight', { clear = true }),
  callback = function()
    draw_my_highlight()
  end,
})

-- Highlight on yank
autocmd('TextYankPost', {
  group = augroup('highlight_yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Jump to last edit position when opening files
autocmd('BufReadPost', {
  group = augroup('last_edit_position', { clear = true }),
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Resize splits if window got resized
autocmd({ 'VimResized' }, {
  group = augroup('resize_splits', { clear = true }),
  callback = function()
    local current_tab = vim.fn.tabpagenr()
    vim.cmd 'tabdo wincmd ='
    vim.cmd('tabnext ' .. current_tab)
  end,
})

-- Check if we need to reload the file when it changed
autocmd({ 'FocusGained', 'TermClose', 'TermLeave' }, {
  group = augroup('checktime', { clear = true }),
  command = 'checktime',
})
