return {

  ---------------------- better `vim.notify()` -----------------------
  {
    "rcarriga/nvim-notify",
    keys = {
      {
        "<leader>un",
        function()
          require("notify").dismiss({ silent = true, pending = true })
        end,
        desc = "Dismiss all Notifications",
      },
    },
    opts = {
      timeout = 2000,
      stages = "slide",
      top_down = false,
      max_height = function()
        return math.floor(vim.o.lines * 0.75)
      end,
      max_width = function()
        return math.floor(vim.o.columns * 0.75)
      end,
    },
    init = function()
      -- when noice is not enabled, install notify on VeryLazy
      local utils = require("utils")
      if not utils.is_available("noice.nvim") then
        utils.on_very_lazy(function()
          vim.notify = require("notify")
        end)
      end
    end,
  },

  ------------------------ better `vim.ui` ---------------------------
  {
    "stevearc/dressing.nvim",
    lazy = true,
    init = function()
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.select = function(...)
        require("lazy").load({ plugins = { "dressing.nvim" } })
        return vim.ui.select(...)
      end
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.input = function(...)
        require("lazy").load({ plugins = { "dressing.nvim" } })
        return vim.ui.input(...)
      end
    end,
  },

  -------------------------- buffer line ------------------------------
  {
    "akinsho/bufferline.nvim",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      options = {
      -- stylua: ignore
      close_command = function(n) require("mini.bufremove").delete(n, false) end,
      -- stylua: ignore
      right_mouse_command = function(n) require("mini.bufremove").delete(n, false) end,
        diagnostics = "nvim_lsp",
        always_show_bufferline = true,
        separator_style = "slant",
        -- indicator = { style = "underline" },
        offsets = {
          {
            filetype = "neo-tree",
            text = "EXPLORER",
            highlight = "Directory",
            text_align = "center",
          },
        },
      },
    },
    keys = {
      { "<leader>bp", "<Cmd>BufferLinePick<CR>", desc = "Pick buffer" },
      { "<leader>bP", "<Cmd>BufferLineTogglePin<CR>", desc = "Toggle pin buffer" },
      { "<leader>bl", "<Cmd>BufferLineCloseLeft<CR>", desc = "Close all buffers to the left" },
      { "<leader>br", "<Cmd>BufferLineCloseRight<CR>", desc = "Close all buffers to the right" },
      { "<leader>bC", "<Cmd>BufferLineGroupClose<CR>", desc = "Close all buffers" },
      { "<leader>bc", "<Cmd>BufferLineCloseOthers<CR>", desc = "Close all buffers except current" },
      { "<leader>bs", desc = "Sort" },
      { "<leader>bse", "<Cmd>BufferLineSortByExtension<CR>", desc = "Sort by extension" },
      { "<leader>bsn", "<Cmd>BufferLineSortByTabs<CR>", desc = "Sort by number" },
      { "<leader>bsp", "<Cmd>BufferLineSortByDirectory<CR>", desc = "Sort by full path" },
      { "<leader>bsr", "<Cmd>BufferLineSortByRelativeDirectory<CR>", desc = "Sort by relative path" },
    },
  },

  -------------------------- status line ------------------------------
  {
    "nvim-lualine/lualine.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = function()
      local utils = require("utils")
      local icons = require("utils.icons")
      local colors = require("utils.colors")
      local colors_default = colors.default

      return {
        options = {
          theme = "auto",
          globalstatus = true,
          disabled_filetypes = { statusline = { "dashboard", "alpha" } },
          component_separators = { left = "", right = "" },
          section_separators = { left = "", right = "" },
        },
        sections = {
          lualine_a = {
            { "mode" },
          },
          lualine_b = {
            {
              "branch",
              icon = { icons.GitBranch },
              on_click = function()
                vim.cmd("Telescope git_branches")
              end,
              color = { fg = colors_default.magenta, bg = "" },
              padding = { left = 1, right = 0 },
            },
          },
          lualine_c = {
            { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
            { "filename", path = 0, symbols = { modified = icons.FileModified, readonly = "", unnamed = "" } },
            {
              "diff",
              symbols = {
                added = icons.GitAdd .. " ",
                modified = icons.GitChange .. " ",
                removed = icons.GitDelete .. " ",
              },
              diff_color = {
                -- Same color values as the general color option can be used here.
                added = { fg = colors_default.green }, -- Changes the diff's added color
                modified = { fg = colors_default.yellow }, -- Changes the diff's modified color
                removed = { fg = colors_default.red1 }, -- Changes the diff's removed color you
              },
              on_click = function()
                vim.cmd("Telescope git_status")
              end,
            },
            {
              "diagnostics",
              symbols = {
                error = icons.DiagnosticError .. " ",
                warn = icons.DiagnosticWarn .. " ",
                info = icons.DiagnosticInfo .. " ",
                hint = icons.DiagnosticHint .. " ",
              },
              diagnostics_color = {
                -- Same values as the general color option can be used here.
                error = { fg = colors_default.red1 }, -- Changes diagnostics' error color.
                warn = { fg = colors_default.yellow }, -- Changes diagnostics' warn color.
                info = { fg = colors_default.blue }, -- Changes diagnostics' info color.
                hint = { fg = colors_default.green }, -- Changes diagnostics' hint color.
              },
              on_click = function()
                vim.cmd("Telescope diagnostics")
              end,
            },
          },
          lualine_x = {
          -- stylua: ignore
          {
            function() return require("noice").api.status.command.get() end,
            cond = function() return package.loaded["noice"] and require("noice").api.status.command.has() end,
            color = utils.fg("Statement"),
          },
          -- stylua: ignore
          {
            function() return "  " .. require("dap").status() end,
            cond = function () return package.loaded["dap"] and require("dap").status() ~= "" end,
            color = utils.fg("Debug"),
          },
            {
              function()
                local names = {}
                for i, server in pairs(vim.lsp.get_active_clients({ bufnr = 0 })) do
                  table.insert(names, server.name)
                end
                return icons.ActiveLSP .. " " .. table.concat(names, " ")
              end,
              color = { fg = colors_default.green },
              on_click = function()
                vim.cmd("LspInfo")
              end,
            },
            {
              'vim.fn["codeium#GetStatusString"]()',
              fmt = function(str)
                return icons.Codeium .. str
              end,
              cond = function()
                local is_exists, _ = pcall(function()
                  return vim.fn["codeium#GetStatusString"]()
                end)
                return is_exists
              end,
              color = { fg = colors_default.green1 },
              on_click = function()
                if vim.fn["codeium#GetStatusString"]() == "OFF" then
                  vim.cmd("CodeiumEnable")
                else
                  vim.cmd("CodeiumDisable")
                end
              end,
            },
            {
              require("lazy.status").updates,
              cond = require("lazy.status").has_updates,
              color = utils.fg("Special"),
              on_click = function()
                vim.cmd("Lazy")
              end,
            },
          },
          lualine_y = {
            {
              "location",
              separator = " ",
              padding = { left = 1, right = 0 },
              color = { bg = "" },
            },
            {
              "progress",
              padding = { left = 1, right = 1 },
              color = { bg = "" },
            },
          },
          lualine_z = {
            function()
              return " " .. os.date("%R")
            end,
          },
        },
        extensions = {
          "aerial",
          "lazy",
          "man",
          "neo-tree",
          "quickfix",
          "toggleterm",
          "trouble",
        },
      }
    end,
  },

  -------------------------- indent guide -----------------------------
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    event = { "BufReadPost", "BufNewFile" },
    config = function(_, opts)
      local highlight = {
        "RainbowRed",
        "RainbowYellow",
        "RainbowBlue",
        "RainbowOrange",
        "RainbowGreen",
        "RainbowViolet",
        "RainbowCyan",
      }
      local hooks = require("ibl.hooks")
      -- create the highlight groups in the highlight setup hook, so they are reset
      -- every time the colorscheme changes
      hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
        vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
        vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
        vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
        vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
        vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
        vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
        vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
      end)

      require("ibl").setup({
        indent = { char = "│" },
        scope = {
          enabled = vim.g.indent_blankline_highlight_scope,
          highlight = highlight,
          include = {
            node_type = { ["*"] = { "*" } },
          },
          show_start = true,
          show_end = true,
        },
        exclude = {
          filetypes = {
            "help",
            "alpha",
            "aerial",
            "dashboard",
            "neo-tree",
            "Trouble",
            "lazy",
            "mason",
            "notify",
            "toggleterm",
            "lazyterm",
          },
        },
      })

      hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)
    end,
  },
  {
    "echasnovski/mini.indentscope",
    enabled = false,
    version = false, -- wait till new 0.7.0 release to put it back on semver
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      -- symbol = "▏",
      symbol = "│",
      options = { try_as_border = true },
    },
    init = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = {
          "help",
          "alpha",
          "aerial",
          "dashboard",
          "neo-tree",
          "Trouble",
          "lazy",
          "mason",
          "notify",
          "toggleterm",
          "lazyterm",
        },
        callback = function()
          vim.b.miniindentscope_disable = true
        end,
      })
    end,
  },

  ----------------------- cmdline and messages ------------------------
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    cond = vim.g.noice_enabled,
    opts = {
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
        progress = {
          format = {
            {
              "{progress} ",
              key = "progress.percentage",
              contents = {
                { "{data.progress.message} " },
              },
            },
            "({data.progress.percentage}%) ",
            { "{spinner} ", hl_group = "NoiceLspProgressSpinner" },
            { "{data.progress.title} ", hl_group = "NoiceLspProgressTitle" },
            { "{data.progress.client} ", hl_group = "NoiceLspProgressClient" },
          },
          format_done = {
            --[[ { icons.LSPLoaded .. " ", hl_group = "NoiceLspProgressSpinner" }, ]]
            { "{data.progress.title} ", hl_group = "NoiceLspProgressTitle" },
            { "{data.progress.client} ", hl_group = "NoiceLspProgressClient" },
          },
        },
      },
      routes = {
        {
          filter = {
            event = "msg_show",
            any = {
              { find = "%d+L, %d+B" },
              { find = "; after #%d+" },
              { find = "; before #%d+" },
            },
          },
          view = "mini",
        },
        -- hide written messages
        {
          filter = {
            event = "msg_show",
            kind = "",
            find = "written",
          },
          opts = { skip = true },
        },
        -- hide search virtual text
        {
          filter = {
            event = "msg_show",
            kind = "search_count",
          },
          opts = { skip = true },
        },
      },
      presets = {
        bottom_search = true,
        command_palette = true,
        long_message_to_split = true,
        inc_rename = true,
        lsp_doc_border = true,
      },
    },
    -- stylua: ignore
    keys = {
      { "<S-Enter>", function() require("noice").redirect(vim.fn.getcmdline()) end, mode = "c", desc = "Redirect Cmdline" },
      { "<leader>fn", function() require("noice").cmd("last") end, desc = "Noice Last Message" },
    },
  },

  ---------------------------- dashboard  -----------------------------
  {
    "goolord/alpha-nvim",
    cmd = "Alpha",
    opts = function()
      local dashboard = require("alpha.themes.dashboard")

      dashboard.section.header.val = {
        [[]],
        [[          ▀████▀▄▄              ▄█ ]],
        [[            █▀    ▀▀▄▄▄▄▄    ▄▄▀▀█ ]],
        [[    ▄        █          ▀▀▀▀▄  ▄▀  ]],
        [[   ▄▀ ▀▄      ▀▄              ▀▄▀  ]],
        [[  ▄▀    █     █▀   ▄█▀▄      ▄█    ]],
        [[  ▀▄     ▀▄  █     ▀██▀     ██▄█   ]],
        [[   ▀▄    ▄▀ █   ▄██▄   ▄  ▄  ▀▀ █  ]],
        [[    █  ▄▀  █    ▀██▀    ▀▀ ▀▀  ▄▀  ]],
        [[   █   █  █      ▄▄           ▄▀   ]],
      }

      local icons = require("utils.icons")
      local button = dashboard.button

      dashboard.section.buttons.val = {
        button("n", icons.FileNew .. "  New File  ", ":ene <BAR> startinsert <CR>"),
        button("f", icons.Search .. "  Find Files  ", ":Telescope find_files<CR>"),
        button("o", icons.DefaultFile .. "  Find Oldfiles ", ":Telescope oldfiles<CR>"),
        button("p", icons.FolderClosed .. "  Find Projects  ", ":Telescope projects<CR>"),
        button("m", icons.Bookmarks .. "  Find Bookmarks  ", ":Telescope marks<CR>"),
        button("s", icons.Refresh .. "  Last Session  ", ":SessionManager load_last_session<CR>"),
        button("c", icons.ActiveLSP .. "  Config  ", ":e $MYVIMRC <CR>"),
        button("l", icons.Lazy .. "  Lazy  ", ":Lazy<CR>"),
        button("q", icons.Quit .. "  Quit  ", ":qa<CR>"),
      }

      for _, _button in ipairs(dashboard.section.buttons.val) do
        _button.opts.hl = "AlphaButtons"
        _button.opts.hl_shortcut = "AlphaShortcut"
      end
      dashboard.section.header.opts.hl = "AlphaHeader"
      dashboard.section.buttons.opts.hl = "AlphaButtons"
      dashboard.section.footer.opts.hl = "AlphaFooter"

      local section = dashboard.section

      dashboard.config.layout = {
        { type = "padding", val = 1 },
        section.header,
        { type = "padding", val = 2 },
        section.buttons,
        { type = "padding", val = 0 },
        section.footer,
      }

      dashboard.config.opts.noautocmd = true

      return dashboard
    end,
    config = function(_, dashboard)
      -- close Lazy and re-open when the dashboard is ready
      if vim.o.filetype == "lazy" then
        vim.cmd.close()
        vim.api.nvim_create_autocmd("User", {
          pattern = "AlphaReady",
          callback = function()
            require("lazy").show()
          end,
        })
      end

      require("alpha").setup(dashboard.opts)

      vim.api.nvim_create_autocmd("User", {
        pattern = "LazyVimStarted",
        desc = "Add Alpha dashboard footer",
        once = true,
        callback = function()
          local stats = require("lazy").stats()
          local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
          dashboard.section.footer.val = "⚡ Neovim loaded " .. stats.count .. " plugins in " .. ms .. "ms"
          pcall(vim.cmd.AlphaRedraw)
        end,
      })
    end,
  },

  ------------------------------ icons  -------------------------------
  {
    "nvim-tree/nvim-web-devicons",
    lazy = true,
    opts = {
      override = {
        default_icon = { icon = require("utils.icons").DefaultFile },
        deb = { icon = "", name = "Deb" },
        lock = { icon = "󰌾", name = "Lock" },
        mp3 = { icon = "󰎆", name = "Mp3" },
        mp4 = { icon = "", name = "Mp4" },
        out = { icon = "", name = "Out" },
        ["robots.txt"] = { icon = "󰚩", name = "Robots" },
        ttf = { icon = "", name = "TrueTypeFont" },
        rpm = { icon = "", name = "Rpm" },
        woff = { icon = "", name = "WebOpenFontFormat" },
        woff2 = { icon = "", name = "WebOpenFontFormat2" },
        xz = { icon = "", name = "Xz" },
        zip = { icon = "", name = "Zip" },
      },
    },
  },

  --------------------------- ui components  --------------------------
  { "MunifTanjim/nui.nvim", lazy = true },

  ----------------------------- fold column  --------------------------
  {
    "kevinhwang91/nvim-ufo",
    enabled = true,
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      "kevinhwang91/promise-async",
      "luukvbaal/statuscol.nvim",
    },
    opts = {
      provider_selector = function()
        return { "treesitter", "indent" }
      end,
    },

    init = function()
      local icons = require("utils.icons")

      vim.opt.foldcolumn = "1" -- show foldcolumn in nvim 0.9
      vim.opt.foldenable = true -- enable fold for nvim-ufo
      vim.opt.foldlevel = 99 -- set high foldlevel for nvim-ufo
      vim.opt.foldlevelstart = 99 -- start with all code unfolded
      vim.opt.fillchars = {
        eob = " ",
        fold = " ",
        foldsep = " ",
        foldopen = icons.FoldOpened, -- +
        foldclose = icons.FoldClosed, -- -
      }

      vim.keymap.set("n", "zR", function()
        require("ufo").openAllFolds()
      end)
      vim.keymap.set("n", "zM", function()
        require("ufo").closeAllFolds()
      end)
    end,
  },
  -- folding preview, by default h and l keys are used.
  { "anuvyklack/fold-preview.nvim", dependencies = "anuvyklack/keymap-amend.nvim", config = true },

  --------------------------- status column  --------------------------
  {
    "luukvbaal/statuscol.nvim",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      local builtin = require("statuscol.builtin")
      require("statuscol").setup({
        relculright = true,
        segments = {
          { text = { builtin.foldfunc }, click = "v:lua.ScFa" }, -- fold column
          { text = { builtin.lnumfunc, " " }, click = "v:lua.ScLa" }, -- number column
          { text = { "%s" }, click = "v:lua.ScSa" }, -- sign column
        },
      })

      -- disable status column for neo-tree
      vim.api.nvim_create_autocmd({ "BufEnter" }, {
        callback = function()
          if vim.bo.filetype == "neo-tree" then
            vim.opt_local.statuscolumn = ""
          end
        end,
      })
    end,
  },

  ----------------------------- drop winbar  --------------------------
  {
    "Bekaboo/dropbar.nvim",
    enabled = true,
    event = { "BufReadPost", "BufNewFile" },
  },

  --------------------------- color highlight -------------------------
  {
    "NvChad/nvim-colorizer.lua",
    event = { "BufReadPre", "BufNewFile" },
    config = true,
  },

  ------------------------- code actions highlight --------------------
  {
    "kosayoda/nvim-lightbulb",
    opts = {
      sign = {
        enabled = true,
        -- Priority of the gutter sign
        priority = 20,
      },
      status_text = {
        enabled = true,
        -- Text to provide when code actions are available
        text = "status_text",
        -- Text to provide when no actions are available
        text_unavailable = "",
      },
      autocmd = {
        enabled = true,
        -- see :help autocmd-pattern
        pattern = { "*" },
        -- see :help autocmd-events
        events = { "CursorHold", "CursorHoldI", "LspAttach" },
      },
    },
  },

  ------------------------- brackets highlight ------------------------
  {
    "HiPhish/rainbow-delimiters.nvim",
    enabled = false,
    dependencies = "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local rainbow_delimiters = require("rainbow-delimiters")
      vim.g.rainbow_delimiters = {
        strategy = {
          [""] = rainbow_delimiters.strategy["globa"],
          vim = rainbow_delimiters.strategy["local"],
        },
        query = {
          [""] = "rainbow-delimiters",
          lua = "rainbow-blocks",
        },
        highlight = {
          "RainbowDelimiterRed",
          "RainbowDelimiterYellow",
          "RainbowDelimiterBlue",
          "RainbowDelimiterOrange",
          "RainbowDelimiterGreen",
          "RainbowDelimiterViolet",
          "RainbowDelimiterCyan",
        },
      }
    end,
  },
}
