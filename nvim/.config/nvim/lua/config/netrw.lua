local map = vim.keymap.set
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- options
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25
vim.g.netrw_liststyle = 3
vim.g.netrw_localcopydircmd = 'cp -r'

-- keymaps
map('n', '<leader>e', '<cmd>Lex<cr>', { desc = 'toggle netrw' })

-- setup some keymaps for netrw
autocmd('FileType', {
  group = augroup('netrw_keymaps', { clear = true }),
  pattern = { 'netrw' },
  callback = function(event)
    local buf_map = vim.api.nvim_buf_set_keymap
    local buf = event.buf
    buf_map(buf, 'n', '<C-l>', '<C-w>l', { noremap = true, silent = true })
    buf_map(buf, 'n', 'H', 'gh', { noremap = true, silent = true })
    buf_map(buf, 'n', 'a', '%:w<CR>:buffer#<CR>', { noremap = true, silent = true })
    buf_map(buf, 'n', 'r', 'R', { noremap = true, silent = true })
    buf_map(buf, 'n', '?', '<F1>', { noremap = true, silent = true })
  end,
})
