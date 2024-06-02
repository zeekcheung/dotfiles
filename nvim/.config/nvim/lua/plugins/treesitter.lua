return {
  -- Syntax highlighting
  {
    'nvim-treesitter/nvim-treesitter',
    dependencies = { 'nvim-treesitter/nvim-treesitter-textobjects' },
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
        -- c/cpp
        'c',
        'cpp',
        -- scripts
        'lua',
        'bash',
        'fish',
        -- vim
        'vim',
        'vimdoc',
        -- markdown
        'markdown',
        'markdown_inline',
        -- misc
        'diff',
        'regex',
        'query',
        'xml',
        'json',
        'jsonc',
        'yaml',
        'toml',
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
