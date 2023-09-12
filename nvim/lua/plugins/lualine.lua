return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  opts = function()
    -- local icons = require("lazyvim.config").icons
    local icons = require("utils.icons")
    local Util = require("lazyvim.util")
    local telescope = require("telescope.builtin")

    return {
      options = {
        theme = "catppuccin",
        globalstatus = true,
        disabled_filetypes = { statusline = { "dashboard", "alpha" } },
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = {
          {
            "branch",
            on_click = function()
              telescope.git_branches()
            end,
          },
        },
        lualine_c = {
          { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
          { "filename", path = 0, symbols = { modified = icons.FileModified, readonly = "", unnamed = "" } },
          {
            "diagnostics",
            symbols = {
              error = icons.DiagnosticError,
              warn = icons.DiagnosticWarn,
              info = icons.DiagnosticInfo,
              hint = icons.DiagnosticHint,
            },
            on_click = function()
              telescope.diagnostics()
            end,
          },
          {
            "diff",
            symbols = {
              added = icons.GitAdd,
              modified = icons.GitChange,
              removed = icons.GitDelete,
            },
            on_click = function()
              telescope.git_status()
            end,
          },
          -- stylua: ignore
          -- {
          --   function() return require("nvim-navic").get_location() end,
          --   cond = function() return package.loaded["nvim-navic"] and require("nvim-navic").is_available() end,
          -- },
        },
        lualine_x = {
          -- stylua: ignore
          {
            function() return require("noice").api.status.command.get() end,
            cond = function() return package.loaded["noice"] and require("noice").api.status.command.has() end,
            color = Util.fg("Statement"),
          },
          -- stylua: ignore
          {
            function() return require("noice").api.status.mode.get() end,
            cond = function() return package.loaded["noice"] and require("noice").api.status.mode.has() end,
            color = Util.fg("Constant"),
          },
          -- stylua: ignore
          {
            function() return "  " .. require("dap").status() end,
            cond = function () return package.loaded["dap"] and require("dap").status() ~= "" end,
            color = Util.fg("Debug"),
          },
          -- { require("lazy.status").updates, cond = require("lazy.status").has_updates, color = Util.fg("Special") },
          {
            'vim.fn["codeium#GetStatusString"]()',
            fmt = function(str)
              return "Codeium " .. str:lower():match("^%s*(.-)%s*$")
            end,
            on_click = function()
              local codeium_status = vim.fn["codeium#GetStatusString"]()
              if codeium_status == "OFF" then
                vim.cmd("CodeiumEnable")
              else
                vim.cmd("CodeiumDisable")
              end
            end,
          },
        },
        lualine_y = {
          { "progress", separator = " ", padding = { left = 1, right = 0 } },
          { "location", padding = { left = 0, right = 1 } },
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
