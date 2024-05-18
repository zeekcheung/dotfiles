local icons = require('util.ui').icons

return {
  -- Status line
  {
    'nvim-lualine/lualine.nvim',
    event = 'VeryLazy',
    opts = function()
      local statusline = {
        lualine_a = {
          {
            'mode',
            fmt = function(str)
              return str:sub(1, 1)
            end,
          },
        },
        lualine_b = {
          {
            'branch',
            icon = '',
            on_click = function()
              vim.cmd 'Telescope git_branches'
            end,
            color = { bg = 'NONE' },
          },
        },
        lualine_c = {
          { 'filetype', icon_only = true, separator = '', padding = { left = 1, right = 0 } },
          { 'filename', padding = { left = 0, right = 1 } },
          {
            'diagnostics',
            symbols = {
              error = icons.diagnostics.Error,
              warn = icons.diagnostics.Warn,
              info = icons.diagnostics.Info,
              hint = icons.diagnostics.Hint,
            },
          },
        },
        lualine_x = {
          -- codeium
          {
            'vim.fn["codeium#GetStatusString"]()',
            cond = function()
              return vim.g.codeium_plugin_enabled
            end,
            fmt = function(str)
              return icons.kinds.Codeium .. str
            end,
            on_click = function()
              vim.cmd 'CodeiumToggle'
            end,
          },
          -- lsp
          {
            function()
              local buf_ft = vim.api.nvim_buf_get_option(0, 'filetype')
              local clients = vim.lsp.get_active_clients()
              for _, client in ipairs(clients) do
                local filetypes = client.config.filetypes
                if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
                  return client.name
                end
              end
            end,
            icon = '󰅡',
            on_click = function()
              vim.cmd 'LspInfo'
            end,
          },
          -- 'encoding',
          -- 'fileformat',
          -- 'filetype',
        },
      }

      -- local winbar = {
      --   lualine_c = {
      --     { 'filetype', icon_only = true,      separator = '', padding = { left = 2, right = 0 } },
      --     { 'filename', padding = { left = 0 } },
      --   },
      -- }

      return {
        options = {
          theme = 'auto',
          globalstatus = true,
          disabled_filetypes = {
            statusline = { 'dashboard' },
            winbar = { 'dashboard', 'neo-tree', 'toggleterm' },
          },
          component_separators = '',
          section_separators = '',
        },
        sections = statusline,
        -- winbar = winbar,
        -- inactive_winbar = winbar,
        extensions = { 'lazy', 'mason', 'neo-tree', 'toggleterm' },
      }
    end,
  },
}
