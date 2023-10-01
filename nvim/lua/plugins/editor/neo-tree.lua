local icons = require("utils.icons")

return {
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
        -- { source = "document_symbols", display_name = icons.Symbol },
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
          --   vim.cmd("edit " .. file_path .. "| startinsert!")
          --   vim.cmd("Neotree Toggle")
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
}
