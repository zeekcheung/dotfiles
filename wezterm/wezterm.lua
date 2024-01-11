local wezterm = require("wezterm")
local act = wezterm.action

local config = {}

if wezterm.config_builder then
	config = wezterm.config_builder()
end

-- Windows shell
config.default_prog = { "pwsh", "-nologo" }
-- WSL
-- config.default_domain = "WSL:Ubuntu-22.04"

-- https://wezfurlong.org/wezterm/colorschemes/index.html
config.color_scheme = "Rosé Pine (base16)"

-- Font
config.font = wezterm.font_with_fallback({
	{ family = "JetBrainsMono Nerd Font", weight = "Regular", italic = true },
	{ family = "RecMonoSemicasual Nerd Font", weight = "Regular", italic = true },
	{ family = "Terminus", weight = "Regular" },
})

config.font_size = 14

-- Change scale to 125%: 96 * 1.25 = 120
config.dpi = 120

-- Dimensions
config.initial_cols = 100
config.initial_rows = 25

config.line_height = 1

config.window_padding = {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
}

-- Tab bar style
config.window_frame = {
	font = wezterm.font({ family = "Roboto", weight = "Bold" }),
	font_size = 10,
	active_titlebar_bg = "#333333",
	inactive_titlebar_bg = "#333333",
}

config.command_palette_rows = 8

config.hide_tab_bar_if_only_one_tab = true

config.animation_fps = 60

config.default_cursor_style = "BlinkingBar"
config.cursor_blink_ease_in = "Constant"
config.cursor_blink_ease_out = "Constant"

config.launch_menu = {
	{ label = "PowerShell", args = { "pwsh", "-nologo" } },
	{ label = "Ubuntu-22.04", args = { "wsl", "~" } },
	{ label = "cmd", args = { "cmd", "/k" } },
}

-- Dim inactive panes
config.inactive_pane_hsb = {
	saturation = 0.24,
	brightness = 0.5,
}

config.window_close_confirmation = "NeverPrompt"

-- https://wezfurlong.org/wezterm/recipes/workspaces.html
-- Wezterm workspaces -> Tmux sessions
-- Wezterm tabs -> Tmux windows
-- Wezterm panes -> Tmux panes
config.default_workspace = "main"

config.mouse_bindings = {
	-- Bind 'Up' event of CTRL-Click to open hyperlinks
	{ event = { Up = { streak = 1, button = "Left" } }, mods = "CTRL", action = act.OpenLinkAtMouseCursor },
	-- Disable the 'Down' event of CTRL-Click to avoid weird program behaviors
	{ event = { Down = { streak = 1, button = "Left" } }, mods = "CTRL", action = act.Nop },
}

-- Change leader key to ctrl+a
config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 1000 }

config.keys = {
	-- Active command palette
	{ key = "F1", mods = "", action = act.ActivateCommandPalette },
	-- Toggle fullscreen
	{ key = "F11", mods = "", action = act.ToggleFullScreen },
	-- Send "CTRL-A" to the terminal when pressing CTRL-A, CTRL-A
	{ key = "a", mods = "LEADER|CTRL", action = act.SendKey({ key = "a", mods = "CTRL" }) },
	-- Vertical split
	{ key = "\\", mods = "LEADER", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
	-- Horizontal split
	{ key = "|", mods = "LEADER|SHIFT", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
	-- Close split panel
	{ key = "q", mods = "LEADER", action = act.CloseCurrentPane({ confirm = false }) },
	-- Close current tab
	{ key = "w", mods = "CTRL|SHIFT", action = wezterm.action.CloseCurrentTab({ confirm = false }) },
	-- Move between split panels
	{ key = "h", mods = "LEADER", action = act.ActivatePaneDirection("Left") },
	{ key = "j", mods = "LEADER", action = act.ActivatePaneDirection("Down") },
	{ key = "k", mods = "LEADER", action = act.ActivatePaneDirection("Up") },
	{ key = "l", mods = "LEADER", action = act.ActivatePaneDirection("Right") },
	-- Resize panels
	{ key = "LeftArrow", mods = "LEADER|CTRL", action = act.AdjustPaneSize({ "Left", 5 }) },
	{ key = "RightArrow", mods = "LEADER|CTRL", action = act.AdjustPaneSize({ "Right", 5 }) },
	{ key = "UpArrow", mods = "LEADER|CTRL", action = act.AdjustPaneSize({ "Up", 5 }) },
	{ key = "DownArrow", mods = "LEADER|CTRL", action = act.AdjustPaneSize({ "Down", 5 }) },
}

-- and finally, return the configuration to wezterm
return config
