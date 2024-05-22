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
    dependencies = { 'nvim-treesitter/nvim-treesitter-textobjects' },
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
      textobjects = {
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            ['af'] = { query = '@function.outer', desc = 'outer function' },
            ['if'] = { query = '@function.inner', desc = 'inner function' },
            ['ac'] = { query = '@class.outer', desc = 'outer class' },
            ['ic'] = { query = '@class.inner', desc = 'inner class' },
            ['aa'] = { query = '@parameter.outer', desc = 'outer argument' },
            ['ia'] = { query = '@parameter.inner', desc = 'inner argument' },
            ['as'] = { query = '@scope', query_group = 'locals', desc = 'outer scope' },
            ['is'] = { query = '@scope', query_group = 'locals', desc = 'inner scope' },
          },
          include_surrounding_whitespace = true,
        },
        move = {
          enable = true,
          set_jumps = true, -- whether to set jumps in the jumplist
          goto_next_start = {
            [']f'] = { query = '@function.outer', desc = 'Next function start' },
            [']c'] = { query = '@class.outer', desc = 'Next class start' },
            [']l'] = { query = '@loop.*', desc = 'Next loop start' },
            [']s'] = { query = '@scope', query_group = 'locals', desc = 'Next scope start' },
            [']z'] = { query = '@fold', query_group = 'folds', desc = 'Next fold start' },
          },
          goto_next_end = {
            [']F'] = { query = '@function.outer', desc = 'Next function end' },
            [']C'] = { query = '@class.outer', desc = 'Next class end' },
            [']L'] = { query = '@loop.*', desc = 'Next loop end' },
            [']S'] = { query = '@scope', query_group = 'locals', desc = 'Next scope end' },
            [']Z'] = { query = '@fold', query_group = 'folds', desc = 'Next fold end' },
          },
          goto_previous_start = {
            ['[f'] = { query = '@function.outer', desc = 'Previous function start' },
            ['[c'] = { query = '@class.outer', desc = 'Previous class start' },
            ['[l'] = { query = '@loop.*', desc = 'Previous loop start' },
            ['[s'] = { query = '@scope', query_group = 'locals', desc = 'Previous scope start' },
            ['[z'] = { query = '@fold', query_group = 'folds', desc = 'Previous fold start' },
          },
          goto_previous_end = {
            ['[F'] = { query = '@function.outer', desc = 'Previous function end' },
            ['[C'] = { query = '@class.outer', desc = 'Previous class end' },
            ['[L'] = { query = '@loop.*', desc = 'Previous loop end' },
            ['[S'] = { query = '@scope', query_group = 'locals', desc = 'Previous scope end' },
            ['[Z'] = { query = '@fold', query_group = 'folds', desc = 'Previous fold end' },
          },
        },
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
    event = { 'BufReadPre', 'BufNewFile' },
    opts = {
      enable = vim.g.sticky_scroll,
      mode = 'cursor',
      max_lines = 5,
    },
  },
}
