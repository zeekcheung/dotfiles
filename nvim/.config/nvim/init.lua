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
  require 'config.filetypes'

  -- neovide
  require 'config.neovide'
end

-- plugins
require 'config.lazy'
