-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

-- This file is automatically loaded by lazyvim.config.init.

-- config neovide
if vim.g.neovide then
  require("utils.neovide").config()
end

-- config pwsh
require("utils.pwsh").config()

-- config rainbow-delimiters
require("utils.rainbow-delimiters").config()
