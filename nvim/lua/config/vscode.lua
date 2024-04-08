local Util = require 'util'
local Vscode = require 'vscode-neovim'

local call = Vscode.call

vim.notify = Vscode.notify

vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'

local opt = vim.opt

-- backup
opt.autowrite = true
opt.swapfile = false
opt.undofile = true
opt.undolevels = 10000

-- indent
opt.shiftwidth = 2
opt.shiftround = true
opt.tabstop = 2
opt.expandtab = true
opt.smartindent = true

-- search
opt.ignorecase = true
opt.smartcase = true

-- misc
opt.clipboard = 'unnamedplus'
opt.inccommand = 'nosplit'
opt.spelllang = { 'en' }
opt.timeoutlen = 300
opt.wrap = false

vim.cmd [[syntax off]]
-- NOTE: setup colorscheme to make sure vscode use correct highlight groups
-- vim.cmd [[colorscheme default]]

-- below value is needed to make some plugins work properly
vim.env.TERM = 'vscode'
vim.g.colorscheme = ''

-- Keymaps
-- Make all keymaps silent by default
local map = Util.silent_map;

-- stylua: ignore
(function()
  -- buffers/tabs
  map('n', '<tab>', function() call 'workbench.action.previousEditor' end)
  map('n', '<S-tab>', function() call 'workbench.action.nextEditor' end)
  map('n', '<leader>x', function() call 'workbench.action.closeActiveEditor' end)
  map('n', '<leader>bd', function() call 'workbench.action.closeActiveEditor' end)
  map('n', '<leader>bc', function() call 'workbench.action.closeAllEditors' end)

  -- code
  map('n', '<leader>ca', function() call 'editor.action.quickFix' end)
  map('n', '<leader>cs', function()
    call 'outline.focus'
    call 'outline.collapse'
  end)
  map('n', '<leader>rn', function() call 'editor.action.rename' end)
  map('n', '<leader>fm', function() call 'editor.action.formatDocument' end)

  -- find
  map('n', '<leader>fc', function() call 'workbench.action.openSettings' end)
  map('n', '<leader>ff', function() call 'workbench.action.quickOpen' end)
  map('n', '<leader>fk', function() call 'workbench.action.openGlobalKeybindings' end)
  map('n', '<leader>fn', function() call 'notifications.showList' end)
  map('n', '<leader>fs', function() call 'workbench.action.gotoSymbol' end)
  map('n', '<leader>fw', function() call 'workbench.action.findInFiles' end)

  -- fold
  map('n', 'za', function() call 'editor.toggleFold' end)
  map('n', 'zc', function() call 'editor.fold' end)
  map('n', 'zM', function() call 'editor.foldAll' end)
  map('n', 'zo', function() call 'editor.unfold' end)
  map('n', 'zR', function() call 'editor.unfoldAll' end)
  map('n', 'zC', function() call 'editor.foldRecursively' end)

  -- git
  map('n', '<leader>gg', function() call 'workbench.scm.focus' end)

  -- goto
  map('n', 'gr', function() call 'references-view.findReferences' end)

  -- indent
  map('v', '>', function() call 'editor.action.indentLines' end)
  map('v', '<', function() call 'editor.action.outdentLines' end)

  -- toggle
  map('n', '<leader>e', function() call 'workbench.action.toggleSidebarVisibility' end)
  map('n', '<leader>z', function() call 'workbench.action.toggleZenMode' end)
  map('n', '<leader>uc', function() call 'workbench.action.selectTheme' end)
  map('n', '<leader>up', function() call 'workbench.actions.view.problems' end)
  map('n', '<leader>uw', function() call 'editor.action.toggleWordWrap' end)

  -- undo/redo
  map('n', 'u', function() call 'undo' end)
  map('n', '<C-r>', function() call 'redo' end)

  -- window navigation
  map({ 'n', 'x' }, '<C-h>', function() call 'workbench.action.navigateLeft' end)
  map({ 'n', 'x' }, '<C-j>', function() call 'workbench.action.navigateDown' end)
  map({ 'n', 'x' }, '<C-k>', function() call 'workbench.action.navigateUp' end)
  map({ 'n', 'x' }, '<C-l>', function() call 'workbench.action.navigateRight' end)

  -- clear search
  map({ 'n', 'i' }, '<esc>', '<cmd>noh<cr><esc>')

  -- quit
  map('n', '<leader>qq', function() call 'workbench.action.closeWindow' end)
  map({ 'n', 'v', 'x' }, '<leader>qw', function() call 'workbench.action.closeActiveEditor' end)

  -- source
  map('n', '<leader>s', '<cmd>so %<cr>')
end)()

-- Autocmds
local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

-- Highlight on yank
autocmd('TextYankPost', {
  group = augroup('highlight_yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})
