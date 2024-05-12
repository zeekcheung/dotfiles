local M = {}

-- NOTE: Some util functions

-- Make all keymaps silent by default
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

-- Get default lua version of the system
function M.get_default_lua_version()
  local handle, error_msg, error_code = io.popen 'lua -v 2>&1'
  if handle == nil then
    return nil, 'Failed to execute lua -v command: ' .. error_msg .. ' (Error code: ' .. tostring(error_code) .. ')'
  end

  ---@type string
  local result = handle:read '*a'
  handle:close()
  return result
end

return M
