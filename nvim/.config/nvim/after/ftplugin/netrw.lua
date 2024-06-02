vim.g.netrw_banner = 0
vim.g.netrw_winsize = 30
vim.g.netrw_altv = 1
vim.g.netrw_liststyle = 3
vim.g.netrw_browse_style = 4
vim.g.netrw_localcopydircmd = 'cp -r'

vim.opt_local.bufhidden = 'wipe'

local map = function(mode, lhs, rhs, opts)
  opts = opts or {}
  opts.remap = opts.remap ~= false
  opts.silent = opts.silent ~= false
  vim.keymap.set(mode, lhs, rhs, opts)
end

map('n', '?', ':help netrw-quickhelp<cr>', { desc = 'Help' })
map('n', '<C-l>', '<C-w>l', { desc = 'Go to right window' })
map('n', '<leader>a', '%', { desc = 'Create new file' })
map('n', '<leader>A', 'd', { desc = 'Create new directory' })
map('n', '<leader>d', 'D', { desc = 'Delete' })
map('n', '<leader>r', 'R', { desc = 'Rename' })
