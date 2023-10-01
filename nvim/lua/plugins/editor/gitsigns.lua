return {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    signs = {
      add = { text = "▎" },
      change = { text = "▎" },
      delete = { text = "" },
      topdelete = { text = "" },
      changedelete = { text = "▎" },
      untracked = { text = "▎" },
    },
    signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
    current_line_blame = true, -- Toggle with `:Gitsigns toggle_current_line_blame`
    current_line_blame_opts = {
      virt_text = true,
      virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
      delay = 1000,
      ignore_whitespace = false,
    },
    current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",
    on_attach = function(buffer)
      local gs = package.loaded.gitsigns
      local wk = require("which-key")

      wk.register({
        ["<leader>gh"] = { name = "hunk" },
        ["<leader>ghs"] = { gs.stage_buffer, "State Buffer" },
        ["<leader>ghu"] = { gs.undo_stage_hunk, "Undo State Hunk" },
        ["<leader>ghr"] = { gs.reset_buffer, "Reset Hunk" },
        ["<leader>ghp"] = { gs.preview_hunk, "Preview Hunk" },
        ["<leader>ghb"] = {
          function()
            gs.blame_line({ full = true })
          end,
          "Blame Line",
        },
        ["<leader>ghd"] = { gs.diffthis, "Diff This" },
        ["<leader>ghD"] = {
          function()
            gs.diffthis("~")
          end,
          "Diff This ~",
        },
      }, { silent = true, buffer = buffer })

      wk.register({
        ["]h"] = { gs.next_hunk, "Next Hunk" },
        ["[h"] = { gs.prev_hunk, "Prev Hunk" },
      }, { silent = true, buffer = buffer })
    end,
  },
}
