return {
  "nvim-lualine/lualine.nvim",
  event = { "BufReadPre", "BufNewFile" },
  opts = function()
    local utils = require("utils")
    local icons = require("utils.icons")
    local colors_default = require("utils.colors").default

    return {
      options = {
        theme = "auto",
        globalstatus = true,
        disabled_filetypes = { statusline = { "dashboard", "alpha" } },
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
            color = { fg = colors_default.magenta },
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
            color = { fg = colors_default.teal },
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
          },
        },
        lualine_y = {
          { "location", separator = " ", padding = { left = 1, right = 0 } },
          { "progress", padding = { left = 0, right = 1 } },
        },
        lualine_z = {
          function()
            return " " .. os.date("%R")
          end,
        },
      },
      extensions = { "neo-tree", "lazy" },
    }
  end,
}
