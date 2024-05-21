-- NOTE:
-- Setting options
-- See `:h vim.o` for more info

vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'

local opt = vim.opt

-- backup
opt.backup = false
opt.swapfile = false
opt.autowrite = true
opt.undofile = true
opt.undolevels = 10000

-- appearance
opt.termguicolors = true
opt.cursorline = true
opt.wrap = true
opt.winminwidth = 5
opt.helpheight = 10

-- conceal
opt.conceallevel = 2
-- opt.concealcursor = 'n'

-- status
opt.number = true
opt.relativenumber = true
opt.signcolumn = 'yes'
opt.foldcolumn = '0'
opt.cmdheight = 0
opt.laststatus = 3
-- opt.statusline = ' %f %m %= %l:%c '

-- indent
opt.shiftround = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.expandtab = true
opt.smartindent = true

-- search
opt.ignorecase = true
opt.smartcase = true

-- scroll
opt.scrolloff = 4
opt.sidescrolloff = 8

-- split
opt.splitbelow = true
opt.splitright = true
opt.splitkeep = 'screen'

-- completion
opt.wildmode = 'longest:full,full'
opt.completeopt = 'menu,menuone,noinsert'
opt.pumblend = 0
opt.pumheight = 10

-- Folding
opt.foldlevel = 99
opt.foldmethod = 'expr'
opt.foldexpr = 'nvim_treesitter#foldexpr()'

-- chars
opt.fillchars = {
  foldopen = '',
  foldclose = '',
  -- fold = "⸱",
  fold = ' ',
  foldsep = ' ',
  diff = '╱',
  eob = ' ',
}
opt.list = false

-- spell
opt.spelllang = { 'en' }

-- misc
opt.mouse = 'a'
opt.clipboard = 'unnamedplus'
opt.timeoutlen = 300
opt.updatetime = 200
opt.virtualedit = 'block'
opt.inccommand = 'nosplit'
opt.formatoptions = 'jcroqlnt'
opt.grepformat = '%f:%l:%c:%m'
opt.grepprg = 'rg --vimgrep'
opt.keywordprg = ':silent! help'
opt.sessionoptions = { 'buffers', 'curdir', 'tabpages', 'winsize', 'help', 'globals', 'skiprtp', 'folds' }
opt.shortmess:append { W = true, I = true, c = true, C = true }
if vim.fn.has 'nvim-0.10' == 1 then
  opt.smoothscroll = true
end

-- Fix markdown indentation settings
vim.g.markdown_recommended_style = 0

-- colorscheme
local transparent_colorschemes = { 'catppuccin', 'rose-pine', 'rose-pine-moon' }
vim.g.colorscheme = 'rose-pine-moon'
vim.g.fallback_colorscheme = vim.fn.has 'nvim-0.10' == 1 and 'sorbet' or 'habamax'
vim.g.transparent_background = vim.tbl_contains(transparent_colorschemes, vim.g.colorscheme)

-- diagnostic
vim.g.diagnostic_opts = {
  signs = false,
  underline = true,
  update_in_insert = false,
  -- virtual_text = {
  --   spacing = 4,
  --   source = 'if_many',
  --   prefix = '●',
  -- },
  severity_sort = true,
  float = { header = false, border = 'rounded', focusable = true },
}

-- scroll
vim.g.sticky_scroll = true -- enable nvim-treesitter-context
vim.g.smooth_scroll = true -- enable neoscroll

-- codeium
vim.g.codeium_plugin_enabled = true
vim.g.codeium_enabled = true
