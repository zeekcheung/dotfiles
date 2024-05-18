return {
  -- Status column
  {
    'luukvbaal/statuscol.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    branch = vim.fn.has 'nvim-0.10' == 1 and '0.10' or 'main',
    init = function()
      -- auto change numberwidth based on the lines of current buffer
      vim.api.nvim_create_autocmd('FileType', {
        pattern = '*',
        callback = function()
          -- get the lines of current buffer
          local lines = vim.api.nvim_buf_line_count(0)
          if lines > 100 then
            vim.opt_local.numberwidth = 5
          elseif lines > 1000 then
            vim.opt_local.numberwidth = 6
          end
        end,
      })
    end,
    config = function()
      local builtin = require 'statuscol.builtin'
      require('statuscol').setup {
        relculright = true,
        ft_ignore = { 'help', 'dashboard', 'NeoTree' },
        segments = {
          { sign = { name = { 'GitSigns', 'todo*' }, namespace = { 'git', 'todo' } }, click = 'v:lua.ScSa' },
          {
            text = { builtin.lnumfunc, ' ' },
            condition = { true, builtin.not_empty },
            click = 'v:lua.ScLa',
          },
          {
            sign = { name = { 'Diagnostic' }, namespace = { 'diagnostic' } },
            condition = { vim.g.diagnostic_opts.signs },
            click = 'v:lua.ScSa',
          },
          -- {
          --   text = { builtin.foldfunc },
          --   condition = { vim.opt.foldcolumn:get() ~= '0' },
          --   click = 'v:lua.ScFa',
          -- },
        },
      }
    end,
  },
}
