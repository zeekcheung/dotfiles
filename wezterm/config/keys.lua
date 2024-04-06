local wezterm = require("wezterm")
local act = wezterm.action

local M = {}

M.setup = function(config)
  local kitty_mod = "CTRL|SHIFT"
  config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 1000 }

  config.keys = {
    -- Active command palette
    { key = "F1",         mods = "",             action = act.ActivateCommandPalette },
    -- Toggle fullscreen
    { key = "F11",        mods = "",             action = act.ToggleFullScreen },
    -- Copy mode(Vim mode)
    { key = "Space",      mods = kitty_mod,      action = act.ActivateCopyMode },

    -- Send "CTRL-A" to the terminal when pressing CTRL-A, CTRL-A
    { key = "a",          mods = "LEADER|CTRL",  action = wezterm.action.SendKey({ key = "a", mods = "CTRL" }) },

    -- Vertical split
    { key = "\\",         mods = "LEADER",       action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
    { key = "\\",         mods = "CTRL",         action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
    -- Horizontal split
    { key = "|",          mods = "LEADER|SHIFT", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
    { key = "|",          mods = kitty_mod,      action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },

    -- Close split panel
    { key = "x",          mods = "LEADER",       action = act.CloseCurrentPane({ confirm = false }) },
    { key = "x",          mods = kitty_mod,      action = act.CloseCurrentPane({ confirm = false }) },

    -- Move between split panels
    { key = "h",          mods = "LEADER",       action = act.ActivatePaneDirection("Left") },
    { key = "j",          mods = "LEADER",       action = act.ActivatePaneDirection("Down") },
    { key = "k",          mods = "LEADER",       action = act.ActivatePaneDirection("Up") },
    { key = "l",          mods = "LEADER",       action = act.ActivatePaneDirection("Right") },
    { key = "h",          mods = kitty_mod,      action = act.ActivatePaneDirection("Left") },
    { key = "j",          mods = kitty_mod,      action = act.ActivatePaneDirection("Down") },
    { key = "k",          mods = kitty_mod,      action = act.ActivatePaneDirection("Up") },
    { key = "l",          mods = kitty_mod,      action = act.ActivatePaneDirection("Right") },

    -- Resize panels
    { key = "UpArrow",    mods = "LEADER",       action = act.AdjustPaneSize({ "Up", 5 }) },
    { key = "DownArrow",  mods = "LEADER",       action = act.AdjustPaneSize({ "Down", 5 }) },
    { key = "LeftArrow",  mods = "LEADER",       action = act.AdjustPaneSize({ "Left", 5 }) },
    { key = "RightArrow", mods = "LEADER",       action = act.AdjustPaneSize({ "Right", 5 }) },
    { key = "UpArrow",    mods = kitty_mod,      action = act.AdjustPaneSize({ "Up", 5 }) },
    { key = "DownArrow",  mods = kitty_mod,      action = act.AdjustPaneSize({ "Down", 5 }) },
    { key = "LeftArrow",  mods = kitty_mod,      action = act.AdjustPaneSize({ "Left", 5 }) },
    { key = "RightArrow", mods = kitty_mod,      action = act.AdjustPaneSize({ "Right", 5 }) },

    -- Create new tab
    { key = "c",          mods = "LEADER",       action = act.SpawnTab("CurrentPaneDomain") },
    -- Close current tab
    { key = "q",          mods = "LEADER",       action = wezterm.action.CloseCurrentTab({ confirm = false }) },

    -- Move between tabs
    { key = "n",          mods = "LEADER",       action = act.ActivateTabRelative(1) },
    { key = "p",          mods = "LEADER",       action = act.ActivateTabRelative(-1) },
    { key = "Tab",        mods = "LEADER",       action = act.ActivateTabRelative(1) },
    { key = "Tab",        mods = kitty_mod,      action = act.ActivateTabRelative(-1) },
  }
end

return M
