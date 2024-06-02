local M = {}

-- NOTE: Some util functions

-- Make all keymaps silent by default
--- @param mode string|string[]
--- @param lhs string
--- @param rhs string|function
--- @param opts? vim.keymap.set.Opts
function M.silent_map(mode, lhs, rhs, opts)
  local keymap_set = vim.keymap.set
  opts = opts or {}
  opts.silent = opts.silent ~= false
  return keymap_set(mode, lhs, rhs, opts)
end

-- Find config files through telescope.nvim
function M.find_configs()
  return require('telescope.builtin').find_files { cwd = vim.fn.stdpath 'config' }
end

return M
