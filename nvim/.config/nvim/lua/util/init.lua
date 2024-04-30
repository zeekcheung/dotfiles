local M = {}

-- NOTE: Some util functions

-- Get default lua version of the system
function M.get_default_lua_version()
  local handle, error_msg, error_code = io.popen('lua -v 2>&1')
  if handle == nil then
    return nil, 'Failed to execute lua -v command: ' .. error_msg .. ' (Error code: ' .. tostring(error_code) .. ')'
  end

  ---@type string
  local result = handle:read('*a')
  handle:close()
  return result
end

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

-- Check if plugin exists
---@param plugin string
function M.has(plugin)
  return require('lazy.core.config').spec.plugins[plugin] ~= nil
end

-- Call fn() on User VeryLazy event
---@param fn fun()
function M.on_very_lazy(fn)
  vim.api.nvim_create_autocmd('User', {
    pattern = 'VeryLazy',
    callback = function()
      fn()
    end,
  })
end

-- Get options of plugin
---@param name string
function M.opts(name)
  local plugin = require('lazy.core.config').plugins[name]
  if not plugin then
    return {}
  end
  local Plugin = require 'lazy.core.plugin'
  return Plugin.values(plugin, 'opts', false)
end

-- Call fn() on plugin load
---@param name string
---@param fn fun(name:string)
function M.on_load(name, fn)
  local Config = require 'lazy.core.config'
  if Config.plugins[name] and Config.plugins[name]._.loaded then
    fn(name)
  else
    vim.api.nvim_create_autocmd('User', {
      pattern = 'LazyLoad',
      callback = function(event)
        if event.data == name then
          fn(name)
          return true
        end
      end,
    })
  end
end

return M
