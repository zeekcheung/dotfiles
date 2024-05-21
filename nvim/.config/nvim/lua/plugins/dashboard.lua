return {
  -- Dashboard
  {
    'nvimdev/dashboard-nvim',
    event = 'VimEnter',
    -- init = function()
    --   vim.opt.ruler = false
    --   vim.opt.showcmd = false
    -- end,
    opts = function()
      local logo = [[
███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝
]]

      logo = string.rep('\n', 1) .. logo .. '\n'

      local opts = {
        theme = 'doom',
        hide = {
          statusline = true,
          tabline = true,
          winbar = true,
        },
        config = {
          header = vim.split(logo, '\n'),
          -- stylua: ignore
          center = {
            { action = 'Telescope find_files', desc = ' Files', icon = ' ', key = 'f' },
            -- { action = "ene | startinsert", desc = " New file", icon = " ", key = "n" },
            { action = 'Telescope oldfiles', desc = ' Recent', icon = ' ', key = 'r' },
            { action = 'Telescope projects', desc = ' Projects', icon = ' ', key = 'p' },
            { action = "lua require('util').find_configs()", desc = ' Config', icon = ' ', key = 'c' },
            { action = "lua require('persistence').load()", desc = ' Session', icon = ' ', key = 's' },
            { action = 'Lazy', desc = ' Lazy', icon = '󰒲 ', key = 'l' },
            { action = 'qa', desc = ' Quit', icon = ' ', key = 'q' },
          },
          footer = function()
            local stats = require('lazy').stats()
            local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
            return {
              '⚡ Neovim loaded ' .. stats.loaded .. '/' .. stats.count .. ' plugins in ' .. ms .. 'ms',
            }
          end,
        },
      }

      for _, button in ipairs(opts.config.center) do
        button.desc = button.desc .. string.rep(' ', 40 - #button.desc)
        button.key_format = '  %s'
      end

      -- close Lazy and re-open when the dashboard is ready
      if vim.o.filetype == 'lazy' then
        vim.cmd.close()
        vim.api.nvim_create_autocmd('User', {
          pattern = 'DashboardLoaded',
          callback = function()
            require('lazy').show()
          end,
        })
      end

      return opts
    end,
  },
}
