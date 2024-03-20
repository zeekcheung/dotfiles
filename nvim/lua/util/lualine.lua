-- NOTE: Some custom `lualine` components
local M = {}

local icons = require('util.ui').icons

function M.branch()
  return {
    'branch',
    padding = { left = 1, right = 0 },
    on_click = function()
      vim.cmd 'Telescope git_branches'
    end,
  }
end

function M.filetype_icon()
  return {
    'filetype',
    icon_only = true,
    separator = '',
    padding = { left = 1, right = 0 },
  }
end

function M.diagnostics()
  return {
    'diagnostics',
    symbols = {
      error = icons.diagnostics.Error,
      warn = icons.diagnostics.Warn,
      info = icons.diagnostics.Info,
      hint = icons.diagnostics.Hint,
    },
    -- always_visible = true,
    on_click = function()
      vim.cmd 'Telescope diagnostics bufnr=0'
    end,
  }
end

function M.filetype()
  return {
    function()
      return vim.bo.filetype
    end,
  }
end

function M.indent()
  return {
    function()
      local shiftwidth = vim.api.nvim_buf_get_option(0, 'shiftwidth')
      return 'Tab:' .. shiftwidth
    end,
    padding = 1,
  }
end

function M.fileformat()
  return {
    'fileformat',
    -- separator = { left = '' },
    padding = { left = 1, right = 2 },
  }
end

function M.lspinfo()
  return {
    function()
      local names = {}

      -- Get all active language servers
      local servers = vim.lsp.get_active_clients { bufnr = 0 }
      for _, server in pairs(servers) do
        table.insert(names, server.name)
      end

      return table.concat(names, ',')
    end,
    on_click = function()
      vim.cmd 'LspInfo'
    end,
  }
end

function M.formatters()
  return {
    function()
      -- Get all active formatters
      local formatters = ''
      local conform_ok, conform = pcall(require, 'conform')
      if conform_ok then
        formatters = table.concat(conform.list_formatters_for_buffer(), ',')
      end
      return formatters
    end,
    on_click = function()
      vim.cmd 'ConformInfo'
    end,
  }
end

function M.linters()
  return {
    function()
      -- Get all active linters
      local status = ''
      local lint_ok, lint = pcall(require, 'lint')
      if lint_ok then
        local linters = lint.linters_by_ft[vim.bo.ft]
        if linters ~= nil then
          status = table.concat(linters, ',')
        end
      end
      return status
    end,
    on_click = function()
      vim.cmd 'LintInfo'
    end,
  }
end

function M.codeium()
  return {
    'vim.fn["codeium#GetStatusString"]()',
    fmt = function(str)
      return icons.kinds.Codeium .. str
    end,
    cond = function()
      return vim.g.codeium_plugin_enabled
    end,
    on_click = function()
      vim.cmd 'CodeiumToggle'
    end,
  }
end

function M.season()
  return {
    function()
      local status = {
        spring = '🌴',
        summer = '🌊',
        autumn = '🎃',
        winter = '🏂',
      }
      local season = M.current_season()

      return status[season]
    end,
  }
end

return M
