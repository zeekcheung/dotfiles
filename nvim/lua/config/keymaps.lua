-- NOTE:
-- Setting Keymaps
-- See `:h vim.keymap.set()` for more info

local Util = require 'util'
local map = Util.silent_map

-- Better escape
map('i', 'jj', '<esc>', { desc = 'Better Escape' })

-- Better indenting
map('v', '<', '<gv')
map('v', '>', '>gv')

-- Better up/down when lines wrap
map({ 'n', 'x' }, 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true })
map({ 'n', 'x' }, '<Down>', "v:count == 0 ? 'gj' : 'j'", { expr = true })
map({ 'n', 'x' }, 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true })
map({ 'n', 'x' }, '<Up>', "v:count == 0 ? 'gk' : 'k'", { expr = true })

-- Misc
map('v', '<C-c>', '"+y', { desc = 'Copy selection' })
map('v', '<C-x>', '"+d', { desc = 'Cut selection' })
map('i', '<C-v>', '<C-r>+', { desc = 'Paste' })
map({ 'n', 'i' }, '<C-z>', '<cmd>undo<cr>', { desc = 'Undo' })
map({ 'n', 'v', 'x', 'i' }, '<C-a>', '<esc>ggVG', { desc = 'Select All' })
map({ 'i', 'x', 'n', 's' }, '<C-s>', '<cmd>w<cr><esc>', { desc = 'Save file' })

-- Move Lines
map('n', '<A-j>', '<cmd>m .+1<cr>==', { desc = 'Move down' })
map('n', '<A-k>', '<cmd>m .-2<cr>==', { desc = 'Move up' })
map('i', '<A-j>', '<esc><cmd>m .+1<cr>==gi', { desc = 'Move down' })
map('i', '<A-k>', '<esc><cmd>m .-2<cr>==gi', { desc = 'Move up' })
map('v', '<A-j>', ":m '>+1<cr>gv=gv", { desc = 'Move down' })
map('v', '<A-k>', ":m '<-2<cr>gv=gv", { desc = 'Move up' })

-- Split
map('n', '|', '<cmd>split<cr>', { desc = 'Horizontal Split' })
map('n', '\\', '<cmd>vsplit<cr>', { desc = 'Vertical Split' })

-- Window navigation
map('n', '<C-h>', '<C-w>h', { desc = 'Go to left window', remap = true })
map('n', '<C-j>', '<C-w>j', { desc = 'Go to lower window', remap = true })
map('n', '<C-k>', '<C-w>k', { desc = 'Go to upper window', remap = true })
map('n', '<C-l>', '<C-w>l', { desc = 'Go to right window', remap = true })

-- Buffers
map('n', '<Tab>', ':bn<cr>', { desc = 'Next buffer' })
map('n', '<S-Tab>', ':bp<cr>', { desc = 'Previous buffer' })
map('n', '<leader>bd', ':bd<cr>', { desc = 'Delete current buffer' })
map('n', '<leader>bo', function()
  local current_buf = vim.fn.bufnr '%'
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if buf ~= current_buf then
      vim.api.nvim_buf_delete(buf, { force = true })
    end
  end
end, { desc = 'Delete other buffers' })

-- Quit
map('n', '<leader>qq', '<cmd>qa<cr>', { desc = 'Quit all' })
map({ 'n', 'v', 'x' }, '<leader>qw', '<cmd>exit<cr>', { desc = 'Quit current window' })

-- Clear search
map({ 'i', 'n' }, '<esc>', '<cmd>noh<cr><esc>', { desc = 'Escape and clear hlsearch' })
-- Clear search, diff update and redraw
map('n', '<leader>ur', '<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>', { desc = 'Redraw / clear hlsearch / diff update' })

-- Diagnostic
local diagnostic_goto = function(next, severity)
  local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
  severity = severity and vim.diagnostic.severity[severity] or nil
  return function()
    ---@diagnostic disable-next-line: missing-fields
    go { severity = severity }
  end
end
map('n', '<leader>d', vim.diagnostic.open_float, { desc = 'Line Diagnostics' })
map('n', ']d', diagnostic_goto(true), { desc = 'Next Diagnostic' })
map('n', '[d', diagnostic_goto(false), { desc = 'Prev Diagnostic' })
map('n', ']e', diagnostic_goto(true, 'ERROR'), { desc = 'Next Error' })
map('n', '[e', diagnostic_goto(false, 'ERROR'), { desc = 'Prev Error' })
map('n', ']w', diagnostic_goto(true, 'WARN'), { desc = 'Next Warning' })
map('n', '[w', diagnostic_goto(false, 'WARN'), { desc = 'Prev Warning' })

-- Lazy
map('n', '<leader>l', '<cmd>Lazy<cr>', { desc = 'Lazy' })

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
map('n', 'n', "'Nn'[v:searchforward].'zv'", { expr = true, desc = 'Next search result' })
map('x', 'n', "'Nn'[v:searchforward]", { expr = true, desc = 'Next search result' })
map('o', 'n', "'Nn'[v:searchforward]", { expr = true, desc = 'Next search result' })
map('n', 'N', "'nN'[v:searchforward].'zv'", { expr = true, desc = 'Prev search result' })
map('x', 'N', "'nN'[v:searchforward]", { expr = true, desc = 'Prev search result' })
map('o', 'N', "'nN'[v:searchforward]", { expr = true, desc = 'Prev search result' })
