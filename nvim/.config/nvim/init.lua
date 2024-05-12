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

if not (vim.fn.has 'win32' == 1) then
  -- enable plugins if not on Windows
  require 'config.lazy'
end
