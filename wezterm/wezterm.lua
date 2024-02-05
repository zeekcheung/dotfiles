local wezterm = require("wezterm")
local act = wezterm.action
local config = {}

if wezterm.config_builder then
	config = wezterm.config_builder()
end

local is_windows = wezterm.target_triple:find("windows")
local is_linux = wezterm.target_triple:find("linux")

-- Windows specific config
if is_windows then
	-- Windows shell
	config.default_prog = { "pwsh", "-nologo" }
	-- WSL
	-- config.default_domain = "WSL:Ubuntu-22.04"

	config.launch_menu = {
		{ label = "PowerShell", args = { "pwsh", "-nologo" } },
		{ label = "Ubuntu-22.04", args = { "wsl", "~" } },
		{ label = "cmd", args = { "cmd", "/k" } },
	}

	-- Change scale to 125%: 96 * 1.25 = 120
	config.dpi = 120
end

if is_linux then
	config.integrated_title_button_style = "Gnome"
else
	config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"

	-- Tab bar
	config.hide_tab_bar_if_only_one_tab = false
	config.use_fancy_tab_bar = false
	config.tab_bar_style = {
		window_hide = " - ",
		window_maximize = " + ",
		window_close = " x ",

		window_hide_hover = " - ",
		window_maximize_hover = " + ",
		window_close_hover = " x ",
	}
end

-- Dimensions
config.initial_cols = 80
config.initial_rows = 20

-- https://wezfurlong.org/wezterm/colorschemes/index.html
-- config.color_scheme = "Rosé Pine (base16)"
config.color_scheme = "Catppuccin Mocha"

-- Custom colors
config.colors = {
	tab_bar = {
		background = "#1e1e2e",
	},
}

-- config.front_end = "WebGpu"
-- config.webgpu_power_preference = "HighPerformance"

-- Font
config.font = wezterm.font_with_fallback({
	-- { family = "Maple Mono NF", weight = "Regular", italic = true },
	{ family = "JetBrainsMono Nerd Font", weight = "Regular", italic = false },
	{ family = "Terminus", weight = "Regular" },
})
config.font_size = 16

-- Padding
config.window_padding = {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
}

-- Command palette
config.command_palette_rows = 8
config.command_palette_bg_color = "#1e1e2e"
config.command_palette_fg_color = "#bbbbbb"
config.command_palette_font_size = 16

config.animation_fps = 60

-- Cursor
config.default_cursor_style = "BlinkingBlock"
-- config.cursor_blink_ease_in = "Constant"
-- config.cursor_blink_ease_out = "Constant"

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
	-- Right click to paste from clipboard
	{
		event = { Down = { streak = 1, button = "Right" } },
		mods = "NONE",
		action = wezterm.action_callback(function(window, pane)
			local has_selection = window:get_selection_text_for_pane(pane) ~= ""
			if has_selection then
				window:perform_action(act.CopyTo("ClipboardAndPrimarySelection"), pane)
				window:perform_action(act.ClearSelection, pane)
			else
				window:perform_action(act({ PasteFrom = "Clipboard" }), pane)
			end
		end),
	},
}

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

-- and finally, return the configuration to wezterm
return config
