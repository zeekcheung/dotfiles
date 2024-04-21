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

if vim.fn.has('unix') ~= 0 then
  -- only enable plugins on unix
  require 'config.lazy'
end
