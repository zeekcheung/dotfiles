-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

local opt = vim.opt

-- backup
opt.backup = false
opt.swapfile = false

-- appearance
opt.helpheight = 10

-- status
opt.foldcolumn = "0"
opt.statusline = " %f %m %= %P  %l:%c "
opt.showcmd = false

-- completion
opt.completeopt = "menu,menuone,noinsert"
opt.pumblend = 0

-- chars
opt.list = false
