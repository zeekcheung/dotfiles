local map = require('util').silent_map
local smart_resize_window = require('util.resize').smart_resize_window
local open_terminal = require('util.terminal').open_terminal
local open_lazygit = require('util.terminal').open_lazygit

-- Better escape
map('i', 'jj', '<esc>', { desc = 'Better Escape' })

-- Better indenting
map('v', '<', '<gv', { desc = 'Indent left' })
map('v', '>', '>gv', { desc = 'Indent right' })

-- Better up/down when lines wrap
map({ 'n', 'x' }, 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true })
map({ 'n', 'x' }, '<Down>', "v:count == 0 ? 'gj' : 'j'", { expr = true })
map({ 'n', 'x' }, 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true })
map({ 'n', 'x' }, '<Up>', "v:count == 0 ? 'gk' : 'k'", { expr = true })

-- Completion
map('i', [[<Tab>]], [[pumvisible() ? "\<C-n>" : "\<Tab>"]], { expr = true })
map('i', [[<S-Tab>]], [[pumvisible() ? "\<C-p>" : "\<S-Tab>"]], { expr = true })

-- Misc
map('v', '<C-c>', '"+y', { desc = 'Copy selection' })
map('v', '<C-x>', '"+d', { desc = 'Cut selection' })
map('i', '<C-v>', '<C-r>+', { desc = 'Paste' })
map({ 'n', 'i' }, '<C-z>', '<cmd>undo<cr>', { desc = 'Undo' })
-- map({ 'n', 'v', 'x', 'i' }, '<C-a>', '<esc>ggVG', { desc = 'Select All' })
map({ 'i', 'x', 'n', 's' }, '<C-s>', '<cmd>w<cr><esc>', { desc = 'Save file' })

-- Go to start/end of line
map('n', 'H', '^', { desc = 'Go to end of line' })
map('n', 'L', '$', { desc = 'Go to start of line' })

-- Move Lines
map('n', '<A-j>', '<cmd>m .+1<cr>==', { desc = 'Move down' })
map('n', '<A-k>', '<cmd>m .-2<cr>==', { desc = 'Move up' })
map('i', '<A-j>', '<esc><cmd>m .+1<cr>==gi', { desc = 'Move down' })
map('i', '<A-k>', '<esc><cmd>m .-2<cr>==gi', { desc = 'Move up' })
map('v', '<A-j>', ":m '>+1<cr>gv=gv", { desc = 'Move down' })
map('v', '<A-k>', ":m '<-2<cr>gv=gv", { desc = 'Move up' })

-- Window splits
map('n', '|', '<cmd>split<cr>', { desc = 'Horizontal Split' })
map('n', '\\', '<cmd>vsplit<cr>', { desc = 'Vertical Split' })

-- Window navigation
map('n', '<C-h>', '<C-w>h', { desc = 'Go to left window', remap = true })
map('n', '<C-j>', '<C-w>j', { desc = 'Go to lower window', remap = true })
map('n', '<C-k>', '<C-w>k', { desc = 'Go to upper window', remap = true })
map('n', '<C-l>', '<C-w>l', { desc = 'Go to right window', remap = true })

-- Window resizing
-- stylua: ignore
map('n', '<C-Left>', function() smart_resize_window 'left' end, { desc = 'Resize window left' })
-- stylua: ignore
map('n', '<C-Right>', function() smart_resize_window 'right' end, { desc = 'Resize window right' })
-- stylua: ignore
map('n', '<C-Up>', function() smart_resize_window 'up' end, { desc = 'Resize window up' })
-- stylua: ignore
map('n', '<C-Down>', function() smart_resize_window 'down' end, { desc = 'Resize window down' })

-- Buffers
map('n', '<Tab>', '<cmd>bn<cr>', { desc = 'Next buffer' })
map('n', '<S-Tab>', '<cmd>bp<cr>', { desc = 'Previous buffer' })
map('n', '<leader>bd', '<cmd>bd<cr>', { desc = 'Delete current buffer' })
map('n', '<leader>bo', '<cmd>silent! %bd|e#|bd#<cr>', { desc = 'Delete other buffers' })

-- Tabs
map('n', '<leader><tab><tab>', '<cmd>tabnew<cr>', { desc = 'New Tab' })
map('n', '<leader><tab>l', '<cmd>tablast<cr>', { desc = 'Last Tab' })
map('n', '<leader><tab>f', '<cmd>tabfirst<cr>', { desc = 'First Tab' })
map('n', '<leader><tab>n', '<cmd>tabnext<cr>', { desc = 'Next Tab' })
map('n', '<leader><tab>d', '<cmd>tabclose<cr>', { desc = 'Close Tab' })
map('n', '<leader><tab>p', '<cmd>tabprevious<cr>', { desc = 'Previous Tab' })

-- Terminal
map('t', '<esc>', [[<C-\><C-n>]], { desc = 'Escape terminal mode' })
map('n', '<leader>th', function()
  open_terminal 'horizontal'
end, { desc = 'Open horizontal terminal' })
map('n', '<leader>tv', function()
  open_terminal 'vertical'
end, { desc = 'Open vertical terminal' })
map('n', '<leader>tf', function()
  open_terminal 'float'
end, { desc = 'Open floating terminal' })
map('n', '<leader>gg', function()
  open_lazygit()
end, { desc = 'Open lazygit' })

-- Netrw
map('n', '<leader>e', '<cmd>Lex<cr>', { desc = 'Open netrw' })

-- Quit
map('n', '<leader>qq', '<cmd>qa<cr>', { desc = 'Quit all' })
map({ 'n', 'v', 'x' }, '<leader>qw', '<cmd>exit<cr>', { desc = 'Quit current window' })

-- Clear search
map({ 'i', 'n' }, '<esc>', '<cmd>noh<cr><esc>', { desc = 'Escape and clear hlsearch' })
-- Clear search, diff update and redraw
map(
  'n',
  '<leader>ur',
  '<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>',
  { desc = 'Redraw / clear hlsearch / diff update' }
)

-- Lazy
map('n', '<leader>l', '<cmd>Lazy<cr>', { desc = 'Lazy' })

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
map('n', 'n', "'Nn'[v:searchforward].'zv'", { expr = true, desc = 'Next search result' })
map('x', 'n', "'Nn'[v:searchforward]", { expr = true, desc = 'Next search result' })
map('o', 'n', "'Nn'[v:searchforward]", { expr = true, desc = 'Next search result' })
map('n', 'N', "'nN'[v:searchforward].'zv'", { expr = true, desc = 'Prev search result' })
map('x', 'N', "'nN'[v:searchforward]", { expr = true, desc = 'Prev search result' })
map('o', 'N', "'nN'[v:searchforward]", { expr = true, desc = 'Prev search result' })
