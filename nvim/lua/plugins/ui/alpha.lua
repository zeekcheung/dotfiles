return {
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
}
