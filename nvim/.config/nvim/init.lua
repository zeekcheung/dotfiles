if vim.loader then
  vim.loader.enable()
end

if vim.g.vscode then
  -- vscode-neovim
  require 'config.vscode'
else
  -- neovim
  require 'config.options'
  require 'config.keymaps'
  require 'config.autocmds'
  require 'config.netrw'

  -- neovide
  require 'config.neovide'
end

if not (vim.fn.has 'win32' == 1) then
  -- enable plugins if not on Windows
  require 'config.lazy'
end
