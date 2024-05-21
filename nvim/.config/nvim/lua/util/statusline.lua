local icons = require('util.ui').icons

local M = {}

---@type number
M.refresh_timeout = 1000

---@type table<string, string>
M.mode_highlights = {
  NORMAL = 'StatusLineNormal',
  INSERT = 'StatusLineInsert',
  VISUAL = 'StatusLineVisual',
  REPLACE = 'StatusLineReplace',
  COMMAND = 'StatusLineCommand',
  TERMINAL = 'StatusLineTerminal',
}

---@type table<string, string[]>
M.mode_map = {
  ['n'] = { 'NORMAL', M.mode_highlights.NORMAL },
  ['no'] = { 'O-PENDING', M.mode_highlights.NORMAL },
  ['nov'] = { 'O-PENDING', M.mode_highlights.NORMAL },
  ['noV'] = { 'O-PENDING', M.mode_highlights.NORMAL },
  ['no\22'] = { 'O-PENDING', M.mode_highlights.NORMAL },
  ['niI'] = { 'NORMAL', M.mode_highlights.INSERT },
  ['niR'] = { 'NORMAL', M.mode_highlights.INSERT },
  ['niV'] = { 'NORMAL', M.mode_highlights.INSERT },
  ['nt'] = { 'NORMAL', M.mode_highlights.NORMAL },
  ['ntT'] = { 'NORMAL', M.mode_highlights.NORMAL },
  ['v'] = { 'VISUAL', M.mode_highlights.VISUAL },
  ['vs'] = { 'VISUAL', M.mode_highlights.VISUAL },
  ['V'] = { 'V-LINE', M.mode_highlights.VISUAL },
  ['Vs'] = { 'V-LINE', M.mode_highlights.VISUAL },
  ['\22'] = { 'V-BLOCK', M.mode_highlights.VISUAL },
  ['\22s'] = { 'V-BLOCK', M.mode_highlights.VISUAL },
  ['s'] = { 'SELECT', M.mode_highlights.VISUAL },
  ['S'] = { 'S-LINE', M.mode_highlights.VISUAL },
  ['\19'] = { 'S-BLOCK', M.mode_highlights.VISUAL },
  ['i'] = { 'INSERT', M.mode_highlights.INSERT },
  ['ic'] = { 'INSERT', M.mode_highlights.INSERT },
  ['ix'] = { 'INSERT', M.mode_highlights.INSERT },
  ['R'] = { 'REPLACE', M.mode_highlights.REPLACE },
  ['Rc'] = { 'REPLACE', M.mode_highlights.REPLACE },
  ['Rx'] = { 'REPLACE', M.mode_highlights.REPLACE },
  ['Rv'] = { 'V-REPLACE', M.mode_highlights.REPLACE },
  ['Rvc'] = { 'V-REPLACE', M.mode_highlights.REPLACE },
  ['Rvx'] = { 'V-REPLACE', M.mode_highlights.REPLACE },
  ['c'] = { 'COMMAND', M.mode_highlights.COMMAND },
  ['cv'] = { 'EX', M.mode_highlights.COMMAND },
  ['ce'] = { 'EX', M.mode_highlights.COMMAND },
  ['r'] = { 'REPLACE', M.mode_highlights.REPLACE },
  ['rm'] = { 'MORE', M.mode_highlights.REPLACE },
  ['r?'] = { 'CONFIRM', M.mode_highlights.REPLACE },
  ['!'] = { 'SHELL', M.mode_highlights.TERMINAL },
  ['t'] = { 'TERMINAL', M.mode_highlights.TERMINAL },
}

---Get current mode
---@return string
function M.mode()
  local mode = vim.api.nvim_get_mode().mode
  return ' ' .. M.mode_map[mode][1] .. ' '
end

---Get highlight for current mode
---@return string
function M.mode_highlight()
  local mode = vim.api.nvim_get_mode().mode
  local highlight = M.mode_map[mode][2]
  return '%#' .. highlight .. '#'
end

function M.diagnostics()
  local severities = { 'Error', 'Warn', 'Info', 'Hint' }
  local str = ''
  local icon, highlight = '', ''

  for _, severity in ipairs(severities) do
    local diagnostics = vim.diagnostic.get(0, { severity = vim.diagnostic.severity[vim.fn.toupper(severity)] })
    icon = icons.diagnostics[severity]
    highlight = 'Diagnostic' .. severity
    if #diagnostics > 0 then
      str = str .. ' %#' .. highlight .. '#' .. icon .. #diagnostics
    end
  end

  return str .. ' '
end

function M.lsp()
  local clients = vim.lsp.get_clients()
  local client_names = {}
  for _, client in ipairs(clients) do
    table.insert(client_names, client.name)
  end
  local icon = '󰅡 '

  return ' ' .. icon .. table.concat(client_names, ', ') .. ' '
end

function M.codeium()
  local ok, status = pcall(vim.fn['codeium#GetStatusString'])
  return ok and ' ' .. '󰘦 ' .. status .. ' ' or ''
end

function M.statusline()
  local filename = ' %t '
  local modified = ' %m '
  -- local percent = ' %P'
  local ruler = ' %l:%c '

  return table.concat {
    M.mode_highlight(),
    M.mode(),
    '%#Normal#',
    filename,
    modified,
    M.diagnostics(),
    '%=',
    M.codeium(),
    M.lsp(),
    M.mode_highlight(),
    -- percent,
    ruler,
  }
end

return M
