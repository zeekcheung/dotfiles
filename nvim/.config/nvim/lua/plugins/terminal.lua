local map = require('util').silent_map

return {
  -- Terminal
  {
    'akinsho/toggleterm.nvim',
    version = '*',
    event = 'VeryLazy',
    config = function()
      local toggleterm = require 'toggleterm'

      local newterm_opts = {
        horizontal = { size = '10', key = '\\' },
        vertical = { size = '50', key = '|' },
      }

      toggleterm.setup {
        -- open_mapping = [[<F7>]],
        size = 10,
        shading_factor = 2,
        direction = 'float',
        float_opts = { border = 'rounded' },
        autochdir = true,
        highlights = {
          Normal = { link = 'Normal' },
          NormalNC = { link = 'NormalNC' },
          NormalFloat = { link = 'NormalFloat' },
          FloatBorder = { link = 'FloatBorder' },
          StatusLine = { link = 'StatusLine' },
          StatusLineNC = { link = 'StatusLineNC' },
          WinBar = { link = 'WinBar' },
          WinBarNC = { link = 'WinBarNC' },
        },
        on_create = function(term)
          -- print(vim.inspect(term, { depth = 2 }))
          local id = term.id
          local direction = term.direction
          local bufnr = term.bufnr

          vim.wo.statuscolumn = ''

          -- close terminal window and exit running progress
          map('n', 'q', '<cmd>bd!<CR>', { buffer = bufnr, noremap = true, silent = true })

          if direction ~= 'float' then
            ---@diagnostic disable-next-line: redefined-local
            local set_newterm_keymap = function(direction)
              local opts = newterm_opts[direction]
              map('n', opts.key, function()
                id = id + 1
                vim.cmd(id .. 'ToggleTerm size=' .. opts.size .. ' direction=' .. direction)
              end, { buffer = bufnr, noremap = true, silent = true })
            end

            set_newterm_keymap 'horizontal'
            set_newterm_keymap 'vertical'
          end
        end,
      }

      if vim.fn.executable 'lazygit' == 1 then
        local Terminal = require('toggleterm.terminal').Terminal

        local lazygit = Terminal:new {
          hidden = true,
          direction = 'float',
          -- function to run on opening the terminal
          on_open = function(term)
            vim.cmd 'startinsert!'
            map('n', 'q', '<cmd>close<CR>', { buffer = term.bufnr, noremap = true, silent = true })
          end,
          -- function to run on closing the terminal
          on_close = function()
            vim.cmd 'startinsert!'
          end,
        }

        function ToggleLazygit()
          lazygit.cmd = 'cd ' .. vim.fn.getcwd() .. ' && lazygit'
          lazygit:toggle()
        end

        map('n', '<leader>gg', '<cmd>lua ToggleLazygit()<CR>', { desc = 'lazygit' })
      end

      map('t', '<esc>', [[<C-\><C-n>]])
      map('n', '<leader>tf', '<cmd>ToggleTerm direction=float<cr>', { desc = 'ToggleTerm float' })
      -- stylua: ignore
      map('n', '<leader>th', '<cmd>ToggleTerm size=' .. newterm_opts['horizontal'].size .. ' direction=horizontal<cr>',
        { desc = 'ToggleTerm horizontal split' })
      -- stylua: ignore
      map('n', '<leader>tv', '<cmd>ToggleTerm size=' .. newterm_opts['vertical'].size .. ' direction=vertical<cr>',
        { desc = 'ToggleTerm vertical split' })
    end,
  },
}
