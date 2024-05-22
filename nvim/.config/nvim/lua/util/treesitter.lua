local M = {}

---@type string
local xdg_config_home = vim.env.XDG_CONFIG_HOME or vim.env.HOME .. '/.config'

---@param package string
local function have_config(package)
  return vim.uv.fs_stat(xdg_config_home .. '/' .. package) ~= nil
end

---Add treesitter parsers for dotfiles
---@param opts {ensure_installed: string[]}
function M.add_dotfiles_parsers(opts)
  ---@param parser string
  local function add_parser(parser)
    if type(opts.ensure_installed) == 'table' then
      table.insert(opts.ensure_installed, parser)
    end
  end

  -- Add parsers
  add_parser 'git_config'
  if have_config 'hypr' then
    add_parser 'hypr'
  end
  if have_config 'fish' then
    add_parser 'fish'
  end
  if have_config 'rofi' or have_config 'wofi' then
    add_parser 'rasi'
  end

  if type(opts.ensure_installed) == 'table' then
    ---@type table<string, boolean>
    local added = {}
    opts.ensure_installed = vim.tbl_filter(function(lang)
      if added[lang] then
        return false
      end
      added[lang] = true
      return true
    end, opts.ensure_installed)
  end
end

return M
