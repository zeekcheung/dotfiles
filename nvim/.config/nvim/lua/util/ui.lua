local M = {}

-- NOTE: Search more icons: https://www.nerdfonts.com/cheat-sheet
M.icons = {
  misc = {
    dots = '󰇘',
  },
  dap = {
    Stopped = { '󰁕 ', 'DiagnosticWarn', 'DapStoppedLine' },
    Breakpoint = ' ',
    BreakpointCondition = ' ',
    BreakpointRejected = { ' ', 'DiagnosticError' },
    LogPoint = '.>',
  },
  diagnostics = {
    -- Error = '● ',
    -- Warn = '● ',
    -- Hint = '● ',
    -- Info = '● ',
    Error = ' ',
    Warn = ' ',
    Hint = ' ',
    Info = ' ',
  },
  file = {
    modified = ' ',
    readOnly = ' ',
    default = '󰈙 ',
  },
  fold = {
    closed = ' ',
    opened = ' ',
    separator = ' ',
  },
  folder = {
    closed = ' ',
    empty = ' ',
    open = ' ',
  },
  git = {
    added = ' ',
    modified = ' ',
    removed = ' ',
    branch = ' ',
    conflict = ' ',
    ignored = '◌ ',
    renamed = '➜ ',
    staged = '✓ ',
    unstaged = '✗ ',
    untracked = '★ ',
  },
  kinds = {
    Array = ' ',
    Boolean = '󰨙 ',
    Class = ' ',
    Codeium = '󰘦 ',
    Color = ' ',
    Control = ' ',
    Collapsed = ' ',
    Constant = '󰏿 ',
    Constructor = ' ',
    Copilot = ' ',
    Enum = ' ',
    EnumMember = ' ',
    Event = ' ',
    Field = ' ',
    File = ' ',
    Folder = ' ',
    Function = '󰊕 ',
    Interface = ' ',
    Key = ' ',
    Keyword = ' ',
    Method = '󰊕 ',
    Module = ' ',
    Namespace = '󰦮 ',
    Null = ' ',
    Number = '󰎠 ',
    Object = ' ',
    Operator = ' ',
    Package = ' ',
    Property = ' ',
    Reference = ' ',
    Snippet = ' ',
    String = ' ',
    Struct = '󰆼 ',
    TabNine = '󰏚 ',
    Text = ' ',
    TypeParameter = ' ',
    Unit = ' ',
    Value = ' ',
    Variable = '󰀫 ',
  },
}

---Border with highlight
---@param hl_name string Highlight name
---@return table
function M.border_with_highlight(hl_name)
  return {
    { '╭', hl_name },
    { '─', hl_name },
    { '╮', hl_name },
    { '│', hl_name },
    { '╯', hl_name },
    { '─', hl_name },
    { '╰', hl_name },
    { '│', hl_name },
  }
end

return M
