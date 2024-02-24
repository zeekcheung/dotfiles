local wezterm = require("wezterm")
local act = wezterm.action

local M = {}

M.setup = function(config)
	config.keys = {
		-- Active command palette
		{ key = "F1", mods = "", action = act.ActivateCommandPalette },
		-- Toggle fullscreen
		{ key = "F11", mods = "", action = act.ToggleFullScreen },
		-- Vertical split
		{ key = "\\", mods = "CTRL", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
		-- Horizontal split
		{ key = "|", mods = "CTRL|SHIFT", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
		-- Close split panel
		{ key = "x", mods = "CTRL|SHIFT", action = act.CloseCurrentPane({ confirm = false }) },
		-- Close current tab
		{ key = "w", mods = "CTRL|SHIFT", action = wezterm.action.CloseCurrentTab({ confirm = false }) },
		-- Move between split panels
		{ key = "h", mods = "CTRL|SHIFT", action = act.ActivatePaneDirection("Left") },
		{ key = "j", mods = "CTRL|SHIFT", action = act.ActivatePaneDirection("Down") },
		{ key = "k", mods = "CTRL|SHIFT", action = act.ActivatePaneDirection("Up") },
		{ key = "l", mods = "CTRL|SHIFT", action = act.ActivatePaneDirection("Right") },
		-- Resize panels
		{ key = "LeftArrow", mods = "CTRL|SHIFT", action = act.AdjustPaneSize({ "Left", 5 }) },
		{ key = "RightArrow", mods = "CTRL|SHIFT", action = act.AdjustPaneSize({ "Right", 5 }) },
		{ key = "UpArrow", mods = "CTRL|SHIFT", action = act.AdjustPaneSize({ "Up", 5 }) },
		{ key = "DownArrow", mods = "CTRL|SHIFT", action = act.AdjustPaneSize({ "Down", 5 }) },
	}
end

return M
