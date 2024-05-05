---@type string
local xdg_config_home = vim.env.XDG_CONFIG_HOME or vim.env.HOME .. '/.config'

---@param package string
local function have_config(package)
  return vim.uv.fs_stat(xdg_config_home .. '/' .. package) ~= nil
end

return {
  -- Syntax highlighting
  {
    'nvim-treesitter/nvim-treesitter',
    opts = function(_, opts)
      ---@param parser string
      local function add_parser(parser)
        if type(opts.ensure_installed) == 'table' then
          table.insert(opts.ensure_installed, parser)
        end
      end

      -- Define some filetypes
      vim.filetype.add({
        extension = {
          rasi = 'rasi',
          rofi = 'rasi',
          wofi = 'rasi',
        },
        filename = {
          ['.env'] = 'dotenv',
          ['vifmrc'] = 'vim',
        },
        pattern = {
          ['.*/waybar/config'] = 'jsonc',
          ['.*/mako/config'] = 'dosini',
          ['.*/kitty/.+%.conf'] = 'kitty',
          ['.*/hypr/.+%.conf'] = 'hyprlang',
          ['%.env%.[%w_.-]+'] = 'dotenv',
        },
      })

      -- Add parsers
      add_parser('git_config')
      if have_config('hypr') then add_parser('hypr') end
      if have_config('fish') then add_parser('fish') end
      if have_config('rofi') or have_config('wofi') then add_parser('rasi') end
    end,
  },
}
