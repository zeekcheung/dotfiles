local opt = vim.opt

--------------------------------- vim.opt ---------------------------------
opt.autowrite = true -- Enable auto write
opt.clipboard = "unnamedplus" -- Sync with system clipboard
opt.cmdheight = 0 -- Hide command line unless needed
opt.completeopt = "menu,menuone,noselect"
opt.conceallevel = 3 -- Hide * markup for bold and italic
opt.confirm = true -- Confirm to save changes before exiting modified buffer
opt.cursorline = true -- Enable highlighting of the current line
opt.expandtab = true -- Use spaces instead of tabs
opt.fileencoding = "utf-8" -- Specify file content encoding for the buffer
opt.foldmethod = "expr" -- Use expression-based folding
opt.foldexpr = "nvim_treesitter#foldexpr()" -- Use treesitter based folding
opt.foldlevel = 99 -- Don't autofold anything
opt.formatoptions = "jcroqlnt" -- Specify format options
opt.grepformat = "%f:%l:%c:%m" -- Specify grep format
opt.grepprg = "rg --vimgrep" -- Use rg as grep program
opt.history = 100 -- Number of commands to remember in a history table
opt.ignorecase = true -- Ignore case when searching
opt.inccommand = "nosplit" -- Preview incremental substitute
opt.laststatus = 0 -- Always show statusline
opt.list = true -- Show some invisible characters (tabs...
opt.mouse = "a" -- Enable mouse mode
opt.number = true -- Show line number
opt.pumblend = 10 -- Popup blend
opt.pumheight = 10 -- Maximum number of entries in a popup
opt.relativenumber = true -- Relative line numbers
opt.scrolloff = 4 -- Lines of context
opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize" } -- Session options
opt.shiftround = true -- Round indent
opt.shiftwidth = 2 -- Size of an indent
opt.shortmess:append({ W = true, I = true, c = true }) -- Shorten messages
opt.showmode = false -- Dont show mode since we have a statusline
opt.sidescrolloff = 8 -- Columns of context
opt.signcolumn = "yes" -- Always show the signcolumn, otherwise it would shift the text each time
opt.smartcase = true -- Don't ignore case with capitals
opt.smartindent = true -- Insert indents automatically
opt.spelllang = { "en" } -- Spell check
opt.splitbelow = true -- Put new windows below current
opt.splitright = true -- Put new windows right of current
opt.swapfile = false -- Disable swap file
opt.tabstop = 2 -- Number of spaces tabs count for
opt.termguicolors = true -- True color support
opt.timeoutlen = 300 -- Time to wait for a mapped sequence
opt.undofile = true -- Enable persistent undo
opt.undolevels = 10000 -- Maximum number of changes that can be undone
opt.updatetime = 200 -- Save swap file and trigger CursorHold
opt.wildmode = "longest:full,full" -- Command-line completion mode
opt.winminwidth = 5 -- Minimum window width
opt.wrap = false -- Disable line wrap
opt.writebackup = false -- Disable making a backup before overwriting a file

if vim.fn.has("nvim-0.9.0") == 1 then
  opt.splitkeep = "screen" -- Keep the current window when splitting
  opt.shortmess:append({ C = true }) -- Don't pass messages to |ins-completion-menu|
  vim.opt.diffopt:append("linematch:60") -- Enable linematch diff algorithm
end

--------------------------------- vim.g ---------------------------------
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
vim.g.markdown_recommended_style = 0 -- Fix markdown indentation settings
vim.g.highlighturl_enabled = false -- Highlight URL
vim.g.dadbod_enabled = false -- Disable vim-dadbod(-ui)
vim.g.noice_enabled = true -- Enable noice.nvim
vim.g.indent_blankline_highlight_scope = false -- Enable indent-blankline.nvim highlight scope
