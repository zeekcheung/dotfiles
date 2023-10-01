local icons = require("utils.icons")

return {

  ------------------------------- explorer ------------------------------
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    cmd = "Neotree",
    keys = {
      {
        "<leader>e",
        function()
          require("neo-tree.command").execute({ toggle = true, dir = vim.loop.cwd() })
        end,
        desc = "Explorer",
      },
      { "<leader>uo", "<cmd>Neotree document_symbols<cr>", desc = "Symbol Outline", silent = true },
    },
    deactivate = function()
      vim.cmd([[Neotree close]])
    end,
    init = function()
      if vim.fn.argc() == 1 then
        local stat = vim.loop.fs_stat(vim.fn.argv(0))
        if stat and stat.type == "directory" then
          require("neo-tree")
        end
      end
    end,
    opts = {
      sources = { "filesystem", "buffers", "git_status", "document_symbols" },
      source_selector = {
        winbar = true, -- toggle to show selector on winbar
        content_layout = "center",
        tabs_layout = "equal",
        show_separator_on_edge = true,
        sources = {
          { source = "filesystem", display_name = icons.FileSystem },
          { source = "buffers", display_name = icons.DefaultFile },
          { source = "git_status", display_name = icons.Git },
          { source = "document_symbols", display_name = icons.Symbol },
          { source = "diagnostics", display_name = icons.Diagnostic },
        },
      },
      open_files_do_not_replace_types = { "terminal", "Trouble", "qf", "Outline" },
      filesystem = {
        bind_to_cwd = false,
        follow_current_file = { enabled = true },
        use_libuv_file_watcher = true,
        filtered_items = {
          visible = true,
          show_hidden_count = true,
          hide_dotfiles = false,
          hide_gitignored = false,
          hide_by_name = {
            -- '.git',
            -- '.DS_Store',
            -- 'thumbs.db',
          },
          never_show = {},
        },
      },
      window = {
        mappings = {
          ["<space>"] = "none",
        },
      },
      default_component_configs = {
        indent = {
          with_expanders = nil, -- if nil and file nesting is enabled, will enable expanders
          expander_collapsed = "",
          expander_expanded = "",
          expander_highlight = "NeoTreeExpander",
        },
        icon = {
          folder_closed = icons.FolderClosed,
          folder_open = icons.FolderOpen,
          folder_empty = icons.FolderEmpty,
          default = icons.DefaultFile,
        },
        modified = { symbol = icons.FileModified },
        git_status = {
          symbols = {
            added = icons.GitAdd,
            deleted = icons.GitDelete,
            modified = icons.GitChange,
            renamed = icons.GitRenamed,
            untracked = icons.GitUntracked,
            ignored = icons.GitIgnored,
            unstaged = icons.GitUnstaged,
            staged = icons.GitStaged,
            conflict = icons.GitConflict,
          },
        },
      },

      -- define custom event handlers
      -- see: https://github.com/nvim-neo-tree/neo-tree.nvim/blob/main/lua/neo-tree/events/init.lua
      event_handlers = {
        -- start editing file after adding
        {
          event = "file_added",
          handler = function(file_path)
            vim.cmd("edit! " .. file_path .. "| startinsert!")
          end,
        },
      },
    },
    config = function(_, opts)
      require("neo-tree").setup(opts)

      local augroup = vim.api.nvim_create_augroup
      local autocmd = vim.api.nvim_create_autocmd

      autocmd("TermClose", {
        pattern = "*lazygit",
        callback = function()
          if package.loaded["neo-tree.sources.git_status"] then
            require("neo-tree.sources.git_status").refresh()
          end
        end,
      })
    end,
  },

  ----------------------------- fuzzy finder ----------------------------
  {
    "nvim-telescope/telescope.nvim",
    commit = vim.fn.has("nvim-0.9.0") == 0 and "057ee0f8783" or nil,
    cmd = "Telescope",
    version = false, -- telescope did only one release, so use HEAD for now
    opts = function()
      local actions = require("telescope.actions")

      return {
        defaults = {
          prompt_prefix = icons.Selected .. " ",
          selection_caret = icons.Selected .. " ",
          path_display = { "truncate" },
          sorting_strategy = "ascending",
          layout_config = {
            horizontal = { prompt_position = "top", preview_width = 0.55 },
            vertical = { mirror = false },
            width = 0.87,
            height = 0.80,
            preview_cutoff = 120,
          },
          mappings = {
            i = {
              ["<C-n>"] = actions.cycle_history_next,
              ["<C-p>"] = actions.cycle_history_prev,
              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,
            },
            n = { q = actions.close },
          },
        },
      }
    end,
    keys = {
      { "<leader>:", "<cmd>Telescope command_history<cr>", desc = "Command History" },
      -- find
      { "<leader>fa", "<cmd>Telescope autocommands<cr>", desc = "Auto Commands" },
      { "<leader>fb", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Buffer" },
      { "<leader>fc", "<cmd>Telescope commands<cr>", desc = "Commands" },
      { "<leader>fd", "<cmd>Telescope diagnostics bufnr=0<cr>", desc = "Document diagnostics" },
      { "<leader>fD", "<cmd>Telescope diagnostics<cr>", desc = "Workspace diagnostics" },
      { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Files" },
      {
        "<leader>fF",
        function()
          require("telescope.builtin").find_files({ hidden = true, no_ignore = true })
        end,
        desc = "Find all files",
      },
      { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help Pages" },
      { "<leader>fk", "<cmd>Telescope keymaps<cr>", desc = "Key Maps" },
      { "<leader>fm", "<cmd>Telescope marks<cr>", desc = "Jump to Mark" },
      { "<leader>fM", "<cmd>Telescope man_pages<cr>", desc = "Man Pages" },
      { "<leader>fn", "<cmd>Telescope notify<cr>", desc = "Notifications" },
      { "<leader>fo", "<cmd>Telescope oldfiles<cr>", desc = "Recent" },
      { "<leader>fr", "<cmd>Telescope registers<cr>", desc = "Registers" },
      { "<leader>fs", "<cmd>Telescope lsp_document_symbols<cr>", desc = "Find symbols" },
      { "<leader>fw", "<cmd>Telescope live_grep<cr>", desc = "Find words" },
      {
        "<leader>fW",
        function()
          require("telescope.builtin").live_grep({
            additional_args = function(args)
              return vim.list_extend(args, { "--hidden", "--no-ignore" })
            end,
          })
        end,
        desc = "Find words in all files",
      },
      {
        "<leader>uc",
        function()
          require("telescope.builtin").colorscheme({ enable_preview = true })
        end,
        desc = "Colorscheme with preview",
      },
      -- git
      { "<leader>gb", "<cmd>Telescope git_branches<CR>", desc = "branches" },
      { "<leader>gc", "<cmd>Telescope git_commits<CR>", desc = "commits" },
      { "<leader>gf", "<cmd>Telescope git_files<CR>", desc = "files" },
      { "<leader>gs", "<cmd>Telescope git_stash<CR>", desc = "statsh" },
      { "<leader>gt", "<cmd>Telescope git_status<CR>", desc = "status" },
    },
  },

  ------------------------------ quick jump -----------------------------
  {
    "folke/flash.nvim",
    event = { "BufReadPost", "BufNewFile" },
    vscode = true,
    ---@type Flash.Config
    opts = {},
    -- stylua: ignore
    keys = {
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
      { "S", mode = { "n", "o", "x" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
      { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
      { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
      { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
    },
  },

  ----------------------------- keymaps popup ---------------------------
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      plugins = { spelling = true },
      ---------------------------------------
      -- 1. Set root keymaps in which-key
      -- 2. Set sub keymaps in other plugins or keymaps.lua
      ---------------------------------------
      defaults = {
        mode = { "n", "v" },
        ["g"] = { name = "goto" },
        ["gz"] = { name = "surround" },
        ["gl"] = { name = "Goto Line" },
        ["]"] = { name = "next" },
        ["["] = { name = "prev" },
        ["<leader>b"] = { name = "Buffer" },
        ["<leader>f"] = { name = "Find" },
        ["<leader>g"] = { name = "Git" },
        ["<leader>l"] = { name = "Lsp" },
        ["<leader>p"] = { name = "Plugins" },
        ["<leader>n"] = { name = "Null-ls" },
        ["<leader>q"] = { name = "Quit" },
        ["<leader>s"] = { name = "Session" },
        ["<leader>t"] = { name = "Terminal" },
        ["<leader>u"] = { name = "UI" },
      },
    },
    config = function(_, opts)
      local wk = require("which-key")
      wk.setup(opts)
      wk.register(opts.defaults)
    end,
  },

  ------------------------------ git highlight --------------------------
  {
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
  },

  ----------------------------- words highlight -------------------------
  {
    "RRethy/vim-illuminate",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      delay = 200,
      large_file_cutoff = 2000,
      large_file_overrides = {
        providers = { "lsp" },
      },
    },
    config = function(_, opts)
      require("illuminate").configure(opts)

      local function map(key, dir, buffer)
        vim.keymap.set("n", key, function()
          require("illuminate")["goto_" .. dir .. "_reference"](false)
        end, { desc = dir:sub(1, 1):upper() .. dir:sub(2) .. " Reference", buffer = buffer })
      end

      map("]]", "next")
      map("[[", "prev")

      -- also set it after loading ftplugins, since a lot overwrite [[ and ]]
      vim.api.nvim_create_autocmd("FileType", {
        callback = function()
          local buffer = vim.api.nvim_get_current_buf()
          map("]]", "next", buffer)
          map("[[", "prev", buffer)
        end,
      })
    end,
    keys = {
      { "]]", desc = "Next Reference" },
      { "[[", desc = "Prev Reference" },
    },
  },

  ------------------------------ buffer remove --------------------------
  {
    "echasnovski/mini.bufremove",
    -- stylua: ignore
    keys = {
      { "<leader>bd", function() require("mini.bufremove").delete(0, false) end, desc = "Delete Buffer" },
      { "<leader>bD", function() require("mini.bufremove").delete(0, true) end, desc = "Delete Buffer (Force)" },
      { "<leader>x", function() require("mini.bufremove").delete(0, false) end, desc = "Delete Buffer" },
    },
  },

  -------------------------- better diagnostics list --------------------
  {
    "folke/trouble.nvim",
    cmd = { "TroubleToggle", "Trouble" },
    opts = { use_diagnostic_signs = true },
    keys = {
      { "<leader>ud", "<cmd>TroubleToggle document_diagnostics<cr>", desc = "Document Diagnostics (Trouble)" },
      {
        "[q",
        function()
          if require("trouble").is_open() then
            require("trouble").previous({ skip_groups = true, jump = true })
          else
            local ok, err = pcall(vim.cmd.cprev)
            if not ok then
              vim.notify(err, vim.log.levels.ERROR)
            end
          end
        end,
        desc = "Previous trouble/quickfix item",
      },
      {
        "]q",
        function()
          if require("trouble").is_open() then
            require("trouble").next({ skip_groups = true, jump = true })
          else
            local ok, err = pcall(vim.cmd.cnext)
            if not ok then
              vim.notify(err, vim.log.levels.ERROR)
            end
          end
        end,
        desc = "Next trouble/quickfix item",
      },
    },
  },

  -------------------------------- todo list ----------------------------
  {
    "folke/todo-comments.nvim",
    cmd = { "TodoTrouble", "TodoTelescope" },
    event = { "BufReadPost", "BufNewFile" },
    config = true,
    -- stylua: ignore
    keys = {
      { "]t", function() require("todo-comments").jump_next() end, desc = "Next todo comment" },
      { "[t", function() require("todo-comments").jump_prev() end, desc = "Previous todo comment" },
      { "<leader>ut", "<cmd>TodoTrouble<cr>", desc = "Todo (Trouble)" },
    },
  },

  -------------------------------- terminal ----------------------------
  {
    "akinsho/toggleterm.nvim",
    cmd = "ToggleTerm",
    config = true,
    opts = {
      open_mapping = [[<c-\]],
      size = 10,
      autochdir = true, -- when neovim changes it current directory the terminal will change it's own when next it's opened
      shading_factor = 2,
      direction = "float",
      float_opts = {
        border = "curved",
        highlights = { border = "Normal", background = "Normal" },
      },
    },
    keys = function()
      local utils = require("utils")
      local default_keys = {
        { "<leader>t", desc = "Terminal" },
        { "<leader>tf", "<cmd>ToggleTerm direction=float<cr>", desc = "ToggleTerm float" },
        { "<leader>th", "<cmd>ToggleTerm size=10 direction=horizontal<cr>", desc = "ToggleTerm horizontal" },
        { "<leader>tv", "<cmd>ToggleTerm size=80 direction=vertical<cr>", desc = "ToggleTerm vertical" },
        -- escape terminal mode
        { mode = "t", "<esc>", [[<C-\><C-n>]], { desc = "Escape Terminal Mode" }, nowait = true },
      }

      local status_ok, toggleterm_terminal = pcall(require, "toggleterm.terminal")
      if status_ok then
        local Terminal = require("toggleterm.terminal").Terminal
        local lazygit = utils.float_term(Terminal, "lazygit", { dir = "git_dir" })
        local node = utils.float_term(Terminal, "node")
        local python = utils.float_term(Terminal, "python")

        function _lazygit_toggle()
          lazygit:toggle()
        end
        function _node_toggle()
          node:toggle()
        end
        function _python_toggle()
          python:toggle()
        end

        local additional_keys = {
          { "<leader>gg", "<cmd>lua _lazygit_toggle()<cr>", desc = "Lazygit" },
          { "<leader>tn", "<cmd>lua _node_toggle()<cr>", desc = "Node" },
          { "<leader>tp", "<cmd>lua _python_toggle()<cr>", desc = "Python" },
        }

        for _, key in ipairs(additional_keys) do
          table.insert(default_keys, key)
        end
      end

      return default_keys
    end,
  },

  ------------------------------ symbol outline -------------------------
  {
    "stevearc/aerial.nvim",
    enabled = false,
    event = { "BufReadPost", "BufNewFile" },
    keys = {
      { "<leader>uo", ":AerialToggle<CR>", desc = "Toggle symbol outline", silent = true },
    },
    opts = {
      attach_mode = "global",
      backends = { "lsp", "treesitter", "markdown", "man" },
      layout = { min_width = 28 },
      show_guides = true,
      filter_kind = false,
      guides = {
        mid_item = "├ ",
        last_item = "└ ",
        nested_top = "│ ",
        whitespace = "  ",
      },
      keymaps = {
        ["[y"] = "actions.prev",
        ["]y"] = "actions.next",
        ["[Y"] = "actions.prev_up",
        ["]Y"] = "actions.next_up",
        ["{"] = false,
        ["}"] = false,
        ["[["] = false,
        ["]]"] = false,
      },
    },
  },
}
