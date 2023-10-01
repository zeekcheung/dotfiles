-- Load/Install lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)

-- Bootstrap lazy.nvim
require("lazy").setup({
  spec = {
    { import = "plugins" },
    { import = "plugins.coding" },
    { import = "plugins.editor" },
    { import = "plugins.ui" },
    { import = "plugins.util" },
    { import = "plugins.lsp" },
    { import = "plugins.lsp.lang.lua", enabled = true },
    { import = "plugins.lsp.lang.bash", enabled = true },
    { import = "plugins.lsp.lang.json", enabled = true },
    { import = "plugins.lsp.lang.yaml", enabled = true },
    { import = "plugins.lsp.lang.toml", enabled = true },
    { import = "plugins.lsp.lang.typescript", enabled = true },
  },
  defaults = {
    lazy = true, -- should plugins be lazy-loaded?
    cond = nil,
  },
  checker = {
    enabled = true, -- automatically check for plugin updates
  },
  change_detection = {
    -- automatically check for config file changes and reload the ui
    enabled = false,
    notify = false, -- get a notification when changes are found
  },
  performance = {
    cache = {
      enabled = true,
    },
    reset_packpath = true, -- reset the package path to improve startup time
    rtp = {
      reset = true, -- reset the runtime path to $VIMRUNTIME and your config directory
      ---@type string[]
      paths = {}, -- add any custom paths here that you want to includes in the rtp
      ---@type string[] list any plugins you want to disable here
      disabled_plugins = {
        "gzip",
        "matchit",
        "matchparen",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
