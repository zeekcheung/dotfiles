local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Define some filetypes
vim.filetype.add {
  extension = {
    rasi = 'rasi',
    rofi = 'rasi',
    wofi = 'rasi',
  },
  filename = {
    ['.env'] = 'dotenv',
    ['vifmrc'] = 'vim',
  },
  pattern = {
    ['.*/waybar/config'] = 'jsonc',
    ['.*/mako/config'] = 'dosini',
    ['.*/kitty/.+%.conf'] = 'kitty',
    ['.*/hypr/.+%.conf'] = 'hyprlang',
    ['%.env%.[%w_.-]+'] = 'dotenv',
  },
}

-- Wrap and check for spell in text filetypes
autocmd('FileType', {
  group = augroup('wrap_spell', { clear = true }),
  pattern = { 'gitcommit', 'markdown' },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})

-- Change indent size for different filetypes
autocmd('FileType', {
  group = augroup('change_options', { clear = true }),
  pattern = { 'c', 'h', 'cpp', 'nu', 'fish', 'vim' },
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
  end,
})

-- Disable conceal of json
autocmd('FileType', {
  group = augroup('json_conceal', { clear = true }),
  pattern = { 'json', 'jsonc', 'json5' },
  callback = function()
    vim.opt_local.conceallevel = 0
  end,
})
