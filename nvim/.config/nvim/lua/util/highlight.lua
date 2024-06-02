local M = {}

---@type table<string, vim.api.keyset.highlight>
M.highlights = {
  -- window
  WinSeparator = { bg = 'NONE', fg = '#4e4d5d' },
  CursorLineNr = { bg = 'NONE' },
  -- border
  NormalFloat = { link = 'Normal' },
  FloatBorder = { fg = '#4e4d5d', bg = 'NONE' },
  HoverBorder = { link = 'CmpBorder' },
  SignatureHelpBorder = { link = 'CmpBorder' },
  LspInfoBorder = { link = 'Normal' },
  -- completion
  -- CmpItemMenu = { bg = "#181825" },
  CmpBorder = { fg = '#4e4d5d' },
  CmpDocBorder = { link = 'CmpBorder' },
  CmpGhostText = { link = 'Comment', default = true },
  -- statusline
  -- StatusLine = { fg = '#ea9a97', bg = '#eb6f92', blend = vim.g.transparent_background and 0 or 10 },
  -- StatusLineNC = { fg = '#908caa', bg = '#2a273f' },
  -- telescope
  TelescopeBorder = { fg = '#56526e', bg = 'none' },
  TelescopeNormal = { bg = 'none' },
  TelescopePromptNormal = { bg = '#232136' },
  TelescopeResultsNormal = { fg = '#e0def4' },
  TelescopeSelection = { fg = '#e0def4', bg = '#393552' },
  -- TelescopeSelectionCaret = { fg = 'rose', bg = 'rose' },
  -- rainbow delimiter
  RainbowDelimiterRed = { fg = '#e67e80' },
  RainbowDelimiterYellow = { fg = '#dbbc7f' },
  RainbowDelimiterBlue = { fg = '#7fbbb3' },
  RainbowDelimiterOrange = { fg = '#e69875' },
  RainbowDelimiterGreen = { fg = '#a7c080' },
  RainbowDelimiterViolet = { fg = '#d699b6' },
}

-- Custom highlight group
function M.draw_my_highlight()
  local ns_id = 0 -- Namespace id, set to 0 for global

  for hl_name, hl_group in pairs(M.highlights) do
    vim.api.nvim_set_hl(ns_id, hl_name, hl_group)
  end
end

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
