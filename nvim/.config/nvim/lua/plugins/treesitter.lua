return {
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },
    opts = {
      textobjects = {
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            ["af"] = { query = "@function.outer", desc = "outer function" },
            ["if"] = { query = "@function.inner", desc = "inner function" },
            ["ac"] = { query = "@class.outer", desc = "outer class" },
            ["ic"] = { query = "@class.inner", desc = "inner class" },
            ["aa"] = { query = "@parameter.outer", desc = "outer argument" },
            ["ia"] = { query = "@parameter.inner", desc = "inner argument" },
            ["as"] = { query = "@scope", query_group = "locals", desc = "outer scope" },
            ["is"] = { query = "@scope", query_group = "locals", desc = "inner scope" },
          },
          include_surrounding_whitespace = true,
        },
        move = {
          enable = true,
          set_jumps = true, -- whether to set jumps in the jumplist
          goto_next_start = {
            ["]f"] = { query = "@function.outer", desc = "Next function start" },
            ["]c"] = { query = "@class.outer", desc = "Next class start" },
            ["]l"] = { query = "@loop.*", desc = "Next loop start" },
            ["]s"] = { query = "@scope", query_group = "locals", desc = "Next scope start" },
            ["]z"] = { query = "@fold", query_group = "folds", desc = "Next fold start" },
          },
          goto_next_end = {
            ["]F"] = { query = "@function.outer", desc = "Next function end" },
            ["]C"] = { query = "@class.outer", desc = "Next class end" },
            ["]L"] = { query = "@loop.*", desc = "Next loop end" },
            ["]S"] = { query = "@scope", query_group = "locals", desc = "Next scope end" },
            ["]Z"] = { query = "@fold", query_group = "folds", desc = "Next fold end" },
          },
          goto_previous_start = {
            ["[f"] = { query = "@function.outer", desc = "Previous function start" },
            ["[c"] = { query = "@class.outer", desc = "Previous class start" },
            ["[l"] = { query = "@loop.*", desc = "Previous loop start" },
            ["[s"] = { query = "@scope", query_group = "locals", desc = "Previous scope start" },
            ["[z"] = { query = "@fold", query_group = "folds", desc = "Previous fold start" },
          },
          goto_previous_end = {
            ["[F"] = { query = "@function.outer", desc = "Previous function end" },
            ["[C"] = { query = "@class.outer", desc = "Previous class end" },
            ["[L"] = { query = "@loop.*", desc = "Previous loop end" },
            ["[S"] = { query = "@scope", query_group = "locals", desc = "Previous scope end" },
            ["[Z"] = { query = "@fold", query_group = "folds", desc = "Previous fold end" },
          },
        },
      },
    },
  },
}
