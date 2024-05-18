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
    branch = 'main',
    event = { 'BufReadPost', 'BufNewFile' },
    cmd = { 'TSUpdateSync', 'TSUpdate', 'TSInstall' },
    build = ':TSUpdate',
    init = function(plugin)
      require('lazy.core.loader').add_to_rtp(plugin)
      require 'nvim-treesitter.query_predicates'
    end,
    keys = {
      { '<c-space>', desc = 'Increment selection' },
      { '<bs>', desc = 'Decrement selection', mode = 'x' },
    },
    ---@diagnostic disable-next-line: missing-fields
    opts = {
      highlight = { enable = true },
      indent = { enable = true },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = '<C-space>',
          node_incremental = '<C-space>',
          scope_incremental = false,
          node_decremental = '<bs>',
        },
      },
      ensure_installed = {
        'bash',
        -- json
        'json',
        'json5',
        'jsonc',
        -- markdown
        'markdown',
        'markdown_inline',
        -- vim
        'vim',
        'vimdoc',
        -- misc
        'diff',
        'regex',
        'query',
        'toml',
        'xml',
        'yaml',
        -- lua
        'lua',
        'luadoc',
        'luap',
        -- c/cpp
        'c',
        'cpp',
        -- webdev
        -- 'html',
        -- 'css',
        -- 'javascript',
        -- 'jsdoc',
        -- 'typescript',
        -- 'tsx',
      },
    },
    config = function(_, opts)
      ---@param parser string
      local function add_parser(parser)
        if type(opts.ensure_installed) == 'table' then
          table.insert(opts.ensure_installed, parser)
        end
      end

      -- Define some filetypes
      vim.filetype.add {
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
      }

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

      require('nvim-treesitter.configs').setup(opts)
    end,
  },

  -- Show context of the current function
  {
    'nvim-treesitter/nvim-treesitter-context',
    cond = vim.g.sticky_scroll,
    event = { 'BufReadPre', 'BufNewFile' },
    opts = { mode = 'cursor', max_lines = 3 },
  },
}
