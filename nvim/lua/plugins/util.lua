return {

  ------------------ library used by other plugins ---------------
  { "nvim-lua/plenary.nvim", lazy = true },

  ------------------------ session manager -----------------------
  {
    "Shatur/neovim-session-manager",
    event = "VeryLazy",
    config = function()
      local Path = require("plenary.path")
      local config = require("session_manager.config")
      require("session_manager").setup({
        sessions_dir = Path:new(vim.fn.stdpath("data"), "sessions"), -- The directory where the session files will be saved.
        autoload_mode = config.AutoloadMode.LastSession, -- Define what to do when Neovim is started without arguments. Possible values: Disabled, CurrentDir, LastSession
        autosave_last_session = true, -- Automatically save last session on exit and on session switch.
        autosave_ignore_not_normal = true, -- Plugin will not save a session when no buffers are opened, or all of them aren't writable or listed.
        autosave_ignore_dirs = {}, -- A list of directories where the session will not be autosaved.
        autosave_ignore_filetypes = { -- All buffers of these file types will be closed before the session is saved.
          "gitcommit",
          "gitrebase",
        },
        autosave_ignore_buftypes = {}, -- All buffers of these bufer types will be closed before the session is saved.
        autosave_only_in_session = false, -- Always autosaves session. If true, only autosaves after a session is active.
        max_path_length = 80, -- Shorten the display path if length exceeds this threshold. Use 0 if don't want to shorten the path at all.
      })
    end,
    keys = {
      { "<leader>sf", ":SessionManager load_session<cr>", desc = "Find session", silent = true },
      { "<leader>sl", ":SessionManager load_last_session<cr>", desc = "Load last session", silent = true },
      {
        "<leader>sc",
        ":SessionManager load_current_dir_session<cr>",
        desc = "Load current dir session",
        silent = true,
      },
      { "<leader>ss", ":SessionManager save_current_session<cr>", desc = "Save current session", silent = true },
      { "<leader>sd", ":SessionManager delete_session<cr>", desc = "Delete session", silent = true },
    },
  },

  ------------------------ project manager -----------------------
  {
    "ahmedkhalf/project.nvim",
    event = "VeryLazy",
    opts = {
      patterns = { ".git", "_darcs", ".hg", ".bzr", ".svn", "Makefile", "package.json", "stylua.toml" },
      exclude_dirs = { "~/.cargo/*" },
    },
    config = function(_, opts)
      require("project_nvim").setup(opts)
      require("telescope").load_extension("projects")
    end,
    keys = {
      { "<leader>fp", "<Cmd>Telescope projects<CR>", desc = "Projects" },
    },
  },

  ------------------------ resize windows ------------------------
  {
    "mrjones2014/smart-splits.nvim",
    event = "BufReadPost",
    keys = {
      { "<C-Up>", "<cmd>SmartResizeUp<cr>", "Resize Up" },
      { "<C-Down>", "<cmd>SmartResizeDown<cr>", "Resize Down" },
      { "<C-Left>", "<cmd>SmartResizeLeft<cr>", "Resize Left" },
      { "<C-Right>", "<cmd>SmartResizeRight<cr>", "Resize Right" },
    },
    opts = {
      -- Ignored filetypes (only while resizing)
      ignored_filetypes = {
        "nofile",
        "quickfix",
        "qf",
        "prompt",
      },
      -- Ignored buffer types (only while resizing)
      ignored_buftypes = { "nofile" },
    },
  },

  ------------------------ windows picker ------------------------
  {
    "s1n7ax/nvim-window-picker",
    name = "window-picker",
    event = { "BufReadPost", "BufNewFile" },
    version = "2.*",
    config = function()
      require("window-picker").setup()
    end,
  },
}
