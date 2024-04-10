if vim.g.vscode then
  -- vscode-neovim
  require 'config.vscode'
else
  -- neovim
  require 'config.options'
  require 'config.keymaps'
  require 'config.autocmds'

  -- neovide
  require 'config.neovide'
end

-- plugins
require 'config.lazy'
