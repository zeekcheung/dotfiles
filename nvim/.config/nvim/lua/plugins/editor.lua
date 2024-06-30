return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      enable_diagnostics = false,
      sources = { "filesystem", "buffers", "git_status", "document_symbols" },
      default_component_configs = {
        indent = {
          with_expanders = false,
        },
        modified = {
          symbol = "",
        },
        git_status = {
          symbols = {
            added = "",
            deleted = "",
            modified = "",
            renamed = "",
            untracked = "",
            ignored = "",
            unstaged = "",
            staged = "",
            conflict = "",
          },
        },
      },
      window = {
        position = "left",
        width = 30,
        mappings = {
          ["<Tab>"] = "next_source",
          ["<S-Tab>"] = "prev_source",
          ["s"] = "none", -- disable default mappings
          ["<leftrelease>"] = "toggle_node",
          ["za"] = "toggle_node",
          ["P"] = {
            "toggle_preview",
            config = { use_float = true, use_image_nvim = true },
          },
        },
      },
      filesystem = {
        bind_to_cwd = true,
        follow_current_file = { enabled = false },
        filtered_items = {
          visible = false,
          show_hidden_count = true,
          hide_dotfiles = true,
          hide_gitignored = true,
          hide_by_name = {},
          always_show = {
            ".config",
            ".local",
            ".bashrc",
            ".bash_profile",
            ".tmux.conf",
            ".vimrc",
            ".zshenv",
            ".zshrc",
          },
          never_show = {},
        },
      },
      buffers = {
        window = {
          mappings = {
            ["d"] = "buffer_delete",
          },
        },
      },

      event_handlers = {
        {
          event = "neo_tree_buffer_enter",
          handler = function()
            vim.opt_local.signcolumn = "no"
            vim.opt_local.statuscolumn = ""
          end,
        },
      },
    },
  },

  {
    "ibhagwan/fzf-lua",
    opts = {
      winopts = {
        preview = {
          layout = "horizontal",
          scrollbar = false,
        },
      },
      defaults = {
        formatter = {
          "path.filename_first",
        },
      },
    },
  },
}
