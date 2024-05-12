local wezterm = require 'wezterm'
local act = wezterm.action

local M = {}

local function table_concat(t1, t2)
  for i = 1, #t2 do
    t1[#t1 + 1] = t2[i]
  end
  return t1
end

function M.set_common_keys(config)
  config.keys = {
    -- Active command palette
    { key = 'F1', mods = '', action = act.ActivateCommandPalette },
    -- Toggle fullscreen
    { key = 'F11', mods = '', action = act.ToggleFullScreen },
    -- Copy mode(Vim mode)
    { key = 'Space', mods = 'CTRL|SHIFT', action = act.ActivateCopyMode },
  }
end

function M.set_kitty_keys(config)
  local kitty_mods = 'CTRL|SHIFT'
  -- Kitty style key bindings
  local kitty_keys = {
    -- Vertical split
    { key = '\\', mods = 'CTRL', action = act.SplitHorizontal { domain = 'CurrentPaneDomain' } },
    -- Horizontal split
    { key = '|', mods = kitty_mods, action = act.SplitVertical { domain = 'CurrentPaneDomain' } },

    -- Close split panel
    { key = 'x', mods = kitty_mods, action = act.CloseCurrentPane { confirm = false } },

    -- Move between split panels
    { key = 'h', mods = kitty_mods, action = act.ActivatePaneDirection 'Left' },
    { key = 'j', mods = kitty_mods, action = act.ActivatePaneDirection 'Down' },
    { key = 'k', mods = kitty_mods, action = act.ActivatePaneDirection 'Up' },
    { key = 'l', mods = kitty_mods, action = act.ActivatePaneDirection 'Right' },

    -- Resize panels
    { key = 'UpArrow', mods = kitty_mods, action = act.AdjustPaneSize { 'Up', 5 } },
    { key = 'DownArrow', mods = kitty_mods, action = act.AdjustPaneSize { 'Down', 5 } },
    { key = 'LeftArrow', mods = kitty_mods, action = act.AdjustPaneSize { 'Left', 5 } },
    { key = 'RightArrow', mods = kitty_mods, action = act.AdjustPaneSize { 'Right', 5 } },

    -- Create new tab
    { key = 'c', mods = kitty_mods, action = act.SpawnTab 'CurrentPaneDomain' },
    -- Close current tab
    { key = 'q', mods = kitty_mods, action = wezterm.action.CloseCurrentTab { confirm = false } },

    -- Move between tabs
    { key = 'n', mods = kitty_mods, action = act.ActivateTabRelative(1) },
    { key = 'p', mods = kitty_mods, action = act.ActivateTabRelative(-1) },
    { key = 'Tab', mods = kitty_mods, action = act.ActivateTabRelative(1) },
  }

  table_concat(config.keys, kitty_keys)
  for i = 1, 9 do
    table.insert(config.keys, { key = tostring(i), mods = 'ALT', action = act.ActivateTab(i - 1) })
  end
end

function M.set_tmux_keys(config)
  config.leader = { key = 'a', mods = 'CTRL', timeout_milliseconds = 1000 }

  -- Tmux style key bindings
  local tmux_keys = {
    -- Send "CTRL-A" to the terminal when pressing CTRL-A, CTRL-A
    { key = 'a', mods = 'LEADER|CTRL', action = wezterm.action.SendKey { key = 'a', mods = 'CTRL' } },

    -- Vertical split
    { key = '\\', mods = 'LEADER', action = act.SplitHorizontal { domain = 'CurrentPaneDomain' } },
    -- Horizontal split
    { key = '|', mods = 'LEADER|SHIFT', action = act.SplitVertical { domain = 'CurrentPaneDomain' } },

    -- Close split panel
    { key = 'x', mods = 'LEADER', action = act.CloseCurrentPane { confirm = false } },

    -- Move between split panels
    { key = 'h', mods = 'LEADER', action = act.ActivatePaneDirection 'Left' },
    { key = 'j', mods = 'LEADER', action = act.ActivatePaneDirection 'Down' },
    { key = 'k', mods = 'LEADER', action = act.ActivatePaneDirection 'Up' },
    { key = 'l', mods = 'LEADER', action = act.ActivatePaneDirection 'Right' },

    -- Resize panels
    { key = 'UpArrow', mods = 'LEADER', action = act.AdjustPaneSize { 'Up', 5 } },
    { key = 'DownArrow', mods = 'LEADER', action = act.AdjustPaneSize { 'Down', 5 } },
    { key = 'LeftArrow', mods = 'LEADER', action = act.AdjustPaneSize { 'Left', 5 } },
    { key = 'RightArrow', mods = 'LEADER', action = act.AdjustPaneSize { 'Right', 5 } },

    -- Create new tab
    { key = 'c', mods = 'LEADER', action = act.SpawnTab 'CurrentPaneDomain' },
    -- Close current tab
    { key = 'q', mods = 'LEADER', action = wezterm.action.CloseCurrentTab { confirm = false } },

    -- Move between tabs
    { key = 'n', mods = 'LEADER', action = act.ActivateTabRelative(1) },
    { key = 'p', mods = 'LEADER', action = act.ActivateTabRelative(-1) },
    { key = 'Tab', mods = 'LEADER', action = act.ActivateTabRelative(1) },
  }

  table_concat(config.keys, tmux_keys)
  for i = 1, 9 do
    table.insert(config.keys, { key = tostring(i), mods = 'LEADER', action = act.ActivateTab(i - 1) })
  end
end

function M.setup(config)
  ---@type "kitty" | "tmux" | "both"
  local key_style = 'kitty'

  M.set_common_keys(config)

  if key_style == 'kitty' then
    M.set_kitty_keys(config)
  elseif key_style == 'tmux' then
    M.set_tmux_keys(config)
  elseif key_style == 'both' then
    M.set_kitty_keys(config)
    M.set_tmux_keys(config)
  end
end

return M
