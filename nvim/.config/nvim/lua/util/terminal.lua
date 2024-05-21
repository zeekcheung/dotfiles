local M = {}

-- Open a new window
--- @param direction "horizontal" | "vertical" | "float"
--- @param enter? boolean
--- @param config? vim.api.keyset.win_config
function M.open_window(direction, enter, config)
  local open_window = vim.api.nvim_open_win
  enter = enter or true
  config = config or {}

  if direction == 'horizontal' then
    return open_window(0, enter, {
      split = 'below',
      height = config.height or 10,
      focusable = config.focusable or true,
      style = config.style or 'minimal',
    })
  elseif direction == 'vertical' then
    return open_window(0, enter, {
      split = 'right',
      width = config.width or 50,
      focusable = config.focusable or true,
      style = config.style or 'minimal',
    })
  elseif direction == 'float' then
    return open_window(0, enter, {
      relative = config.relative or 'editor',
      width = config.width or 85,
      height = config.height or 19,
      row = config.row or 1,
      col = config.col or 8,
      focusable = config.focusable or true,
      zindex = config.zindex or 50,
      style = config.style or 'minimal',
      border = config.border or 'rounded',
    })
  end
end

-- Open a new terminal
--- @param direction "horizontal" | "vertical" | "float"
--- @param opts? { enter?: boolean, config?: vim.api.keyset.win_config, cmd?: string, startinsert?: boolean }
function M.open_terminal(direction, opts)
  opts = opts or {}
  -- Open a new window
  local win = M.open_window(direction, opts.enter, opts.config)

  -- Windows specific options
  local opt = vim.opt_local
  if vim.fn.has 'win32' ~= 0 then
    -- Change default shell to PowerShell on Windows
    -- NOTE:
    -- 1. Codeium cannot use PowerShell to authenticate
    --    so we need to comment it out when we authenticate with Codeium
    -- 2. We need to add PowerShell to the `PATH` for `vim.fn.executable 'pwsh'` to work
    opt.shell = vim.fn.executable 'pwsh' == 1 and 'pwsh' or 'Powershell'
    opt.shellcmdflag =
      '-NoLogo -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;'
    opt.shellredir = '-RedirectStandardOutput %s -NoNewWindow -Wait'
    opt.shellpipe = '2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode'
    opt.shellquote = ''
    opt.shellxquote = ''
  end

  -- Open terminal in current window
  vim.cmd.terminal(opts.cmd or vim.env.SHELL)

  -- Close terminal on <q>
  vim.api.nvim_buf_set_keymap(0, 'n', 'q', '<cmd>close!<CR>', { noremap = true, silent = true })

  -- Do not show [Process exited] in finished terminals
  -- https://github.com/neovim/neovim/issues/14986#issuecomment-902705190
  vim.cmd "autocmd TermClose * silent! execute 'bdelete! ' . expand('<abuf>')"

  -- Start insert mode
  opts.startinsert = opts.startinsert == nil and true or opts.startinsert
  if opts.startinsert then
    vim.cmd.startinsert()
  end

  return win
end

-- Open lazygit
function M.open_lazygit()
  M.open_terminal('float', { cmd = 'lazygit', config = { zindex = 200 }, startinsert = true })
end

return M
