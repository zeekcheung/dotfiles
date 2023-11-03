if not vim.g.vscode then
  return {}
end

---------------------------------------------------
------------------ Setup options ------------------
---------------------------------------------------

local opt = vim.opt

opt.autowrite = true          -- Enable auto write
opt.clipboard = "unnamedplus" -- Sync with system clipboard
opt.expandtab = true          -- Use spaces instead of tabs
opt.grepformat = "%f:%l:%c:%m"
opt.grepprg = "rg --vimgrep"
opt.ignorecase = true      -- Ignore case
opt.inccommand = "nosplit" -- preview incremental substitute
opt.shiftround = true      -- Round indent
opt.shiftwidth = 2         -- Size of an indent
opt.smartcase = true       -- Don't ignore case with capitals
opt.smartindent = true     -- Insert indents automatically
opt.spelllang = { "en" }
opt.tabstop = 2            -- Number of spaces tabs count for
opt.timeoutlen = 300
opt.undofile = true
opt.undolevels = 10000
opt.wrap = false -- Disable line wrap

---------------------------------------------------
------------------ Setup keymaps ------------------
---------------------------------------------------

local vscode = require("vscode-neovim")
local call = vscode.call

-- make all keymaps silent by default
local function map(mode, lhs, rhs, opts)
  opts = opts or {}
  opts.silent = opts.silent ~= false
  vim.keymap.set(mode, lhs, rhs, opts)
end

-- show vscode notifications
vim.notify = vscode.notify

-- leader key
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- buffers/tabs
map("n", "H", function() call("workbench.action.previousEditor") end)
map("n", "L", function() call("workbench.action.nextEditor") end)
map("n", "<leader>x", function() call("workbench.action.closeActiveEditor") end)
map("n", "<leader>bc", function() call("workbench.action.closeAllEditors") end)

-- code
map("n", "<leader>ca", function() call("editor.action.quickFix") end)
map("n", "<leader>cr", function() call("editor.action.rename") end)
map("n", "<leader>cf", function() call("editor.action.formatDocument") end)
map("n", "<leader>cs", function()
  call("outline.focus")
  call("outline.collapse")
end)

-- find
map("n", "<leader>fc", function() call("workbench.action.openSettings") end)
map("n", "<leader>fC", function() call("workbench.action.showCommands") end)
map("n", "<leader>ff", function() call("workbench.action.quickOpen") end)
map("n", "<leader>fk", function() call("workbench.action.openGlobalKeybindings") end)
map("n", "<leader>fn", function() call("notifications.showList") end)
map("n", "<leader>fs", function() call("workbench.action.gotoSymbol") end)
map("n", "<leader>fw", function() call("workbench.action.findInFiles") end)

-- fold
map("n", "za", function() call("editor.toggleFold") end)
map("n", "zc", function() call("editor.fold") end)
map("n", "zM", function() call("editor.foldAll") end)
map("n", "zo", function() call("editor.unfold") end)
map("n", "zR", function() call("editor.unfoldAll") end)
map("n", "zC", function() call("editor.foldRecursively") end)

-- git
map("n", "<leader>gg", function() call("workbench.scm.focus") end)

-- goto
map("n", "gr", function() call("references-view.findReferences") end)
map("n", "gi", function() call("editor.action.goToImplementation") end)

-- toggle
map("n", "<leader>e", function() call("workbench.action.toggleSidebarVisibility") end)
map("n", "<leader>z", function() call("workbench.action.toggleZenMode") end)
map("n", "<leader>uc", function() call("workbench.action.selectTheme") end)
map("n", "<leader>up", function() call("workbench.actions.view.problems") end)
map("n", "<leader>uw", function() call("editor.action.toggleWordWrap") end)


---------------------------------------------------
--------------- Bootstrap lazy.nvim ---------------
---------------------------------------------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  -- bootstrap lazy.nvim
  -- stylua: ignore
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable",
    lazypath })
end
vim.opt.rtp:prepend(vim.env.LAZY or lazypath)

---------------------------------------------------
------------------ Setup plugins ------------------
---------------------------------------------------
require("lazy").setup({
  defaults = {
    lazy = true,
    version = false, -- always use the latest git commit
  },
  checker = {
    enabled = false,
    notify = false,   -- get a notification when new updates are found
    frequency = 3600, -- check for updates every hour
  },
  change_detection = {
    enabled = false,
    notify = false, -- get a notification when changes are found
  },
  performance = {
    cache = {
      enabled = true,
      -- disable_events = {},
    },
    rtp = {
      -- disable some rtp plugins
      disabled_plugins = {
        "gzip",
        -- "matchit",
        -- "matchparen",
        -- "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
  spec = {
    {
      "folke/flash.nvim",
      event = "VeryLazy",
      vscode = true,
      ---@type Flash.Config
      opts = {},
      -- stylua: ignore
      keys = {
        { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end,   desc = "Flash" },
        {
          "S",
          mode = { "n", "o", "x" },
          function() require("flash").treesitter() end,
          desc =
          "Flash Treesitter"
        },
        { "r", mode = "o",               function() require("flash").remote() end, desc = "Remote Flash" },
        {
          "R",
          mode = "n",
          function() require("flash").treesitter_search() end,
          desc =
          "Treesitter Search"
        },
        {
          "<c-s>",
          mode = { "c" },
          function() require("flash").toggle() end,
          desc =
          "Toggle Flash Search"
        },
      },
    },

    {
      "echasnovski/mini.pairs",
      event = "VeryLazy",
      vscode = true,
      opts = {},
    },

    {
      "echasnovski/mini.comment",
      event = "VeryLazy",
      vscode = true,
      opts = {},
    },

    {
      "nvim-treesitter/nvim-treesitter",
      version = false, -- last release is way too old and doesn't work on Windows
      build = ":TSUpdate",
      event = "VeryLazy",
      init = function(plugin)
        -- PERF: add nvim-treesitter queries to the rtp and it's custom query predicates early
        -- This is needed because a bunch of plugins no longer `require("nvim-treesitter")`, which
        -- no longer trigger the **nvim-treeitter** module to be loaded in time.
        -- Luckily, the only thins that those plugins need are the custom queries, which we make available
        -- during startup.
        require("lazy.core.loader").add_to_rtp(plugin)
        require("nvim-treesitter.query_predicates")
      end,
      dependencies = {
        {
          "nvim-treesitter/nvim-treesitter-textobjects",
          config = function()
            -- When in diff mode, we want to use the default
            -- vim text objects c & C instead of the treesitter ones.
            local move = require("nvim-treesitter.textobjects.move") ---@type table<string,fun(...)>
            local configs = require("nvim-treesitter.configs")
            for name, fn in pairs(move) do
              if name:find("goto") == 1 then
                move[name] = function(q, ...)
                  if vim.wo.diff then
                    local config = configs.get_module("textobjects.move")[name] ---@type table<string,string>
                    for key, query in pairs(config or {}) do
                      if q == query and key:find("[%]%[][cC]") then
                        vim.cmd("normal! " .. key)
                        return
                      end
                    end
                  end
                  return fn(q, ...)
                end
              end
            end
          end,
        },
      },
      cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
      keys = {
        { "<c-space>", desc = "Increment selection" },
        { "<bs>",      desc = "Decrement selection", mode = "x" },
      },
      ---@type TSConfig
      ---@diagnostic disable-next-line: missing-fields
      opts = {
        highlight = { enable = true },
        indent = { enable = true },
        ensure_installed = {
          "bash",
          "c",
          "diff",
          "html",
          "javascript",
          "jsdoc",
          "json",
          "jsonc",
          "lua",
          "luadoc",
          "luap",
          "markdown",
          "markdown_inline",
          "python",
          "query",
          "regex",
          "toml",
          "tsx",
          "typescript",
          "vim",
          "vimdoc",
          "yaml",
        },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "<C-space>",
            node_incremental = "<C-space>",
            scope_incremental = false,
            node_decremental = "<bs>",
          },
        },
        textobjects = {
          move = {
            enable = true,
            goto_next_start = { ["]f"] = "@function.outer", ["]c"] = "@class.outer" },
            goto_next_end = { ["]F"] = "@function.outer", ["]C"] = "@class.outer" },
            goto_previous_start = { ["[f"] = "@function.outer", ["[c"] = "@class.outer" },
            goto_previous_end = { ["[F"] = "@function.outer", ["[C"] = "@class.outer" },
          },
        },
      },
      ---@param opts TSConfig
      config = function(_, opts)
        if type(opts.ensure_installed) == "table" then
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
        require("nvim-treesitter.configs").setup(opts)
      end,
    },

    {
      'echasnovski/mini.ai',
      event = "VeryLazy",
      opts = function()
        local ai = require("mini.ai")
        return {
          n_lines = 500,
          custom_textobjects = {
            o = ai.gen_spec.treesitter({
              a = { "@block.outer", "@conditional.outer", "@loop.outer" },
              i = { "@block.inner", "@conditional.inner", "@loop.inner" },
            }, {}),
            f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }, {}),
            c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }, {}),
            t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" },
          },
        }
      end,
      config = function(_, opts)
        require("mini.ai").setup(opts)

        map("n", "i ", "Whitespace")
        map("n", 'i"', 'Balanced "')
        map("n", "i'", "Balanced '")
        map("n", "i`", "Balanced `")
        map("n", "i(", "Balanced (")
        map("n", "i)", "Balanced ) including white-space")
        map("n", "i>", "Balanced > including white-space")
        map("n", "i<lt>", "Balanced <")
        map("n", "i]", "Balanced ] including white-space")
        map("n", "i[", "Balanced [")
        map("n", "i}", "Balanced } including white-space")
        map("n", "i{", "Balanced {")
        map("n", "i?", "User Prompt")
        map("n", "i_", "Underscore")
        map("n", "ia", "Argument")
        map("n", "ib", "Balanced ), ], }")
        map("n", "ic", "Class")
        map("n", "if", "Function")
        map("n", "io", "Block, conditional, loop")
        map("n", "iq", "Quote `, \", '")
        map("n", "it", "Tag")

        map("n", "a ", "Whitespace")
        map("n", 'a"', 'Balanced "')
        map("n", "a'", "Balanced '")
        map("n", "a`", "Balanced `")
        map("n", "a(", "Balanced (")
        map("n", "a)", "Balanced ) including white-space")
        map("n", "a>", "Balanced > including white-space")
        map("n", "a<lt>", "Balanced <")
        map("n", "a]", "Balanced ] including white-space")
        map("n", "a[", "Balanced [")
        map("n", "a}", "Balanced } including white-space")
        map("n", "a{", "Balanced {")
        map("n", "a?", "User Prompt")
        map("n", "a_", "Underscore")
        map("n", "aa", "Argument")
        map("n", "ab", "Balanced ), ], }")
        map("n", "ac", "Class")
        map("n", "af", "Function")
        map("n", "ao", "Block, conditional, loop")
        map("n", "aq", "Quote `, \", '")
        map("n", "at", "Tag")
      end
    },
  }
})
