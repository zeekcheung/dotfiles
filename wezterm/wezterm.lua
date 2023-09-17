-- Pull in the wezterm API
local wezterm = require("wezterm")
local mux = wezterm.mux

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
	config = wezterm.config_builder()
end

-- This is where you actually apply your config choices

-- For example, changing the color scheme:
config.color_scheme = "tokyonight_moon"

config.font = wezterm.font_with_fallback({
	{ family = "RecMonoSemicasual Nerd Font", weight = "Regular", italic = true },
	{ family = "JetBrains Mono", weight = "Medium", italic = true },
	{ family = "Terminus", weight = "Bold" },
})
config.font_size = 18

config.hide_tab_bar_if_only_one_tab = true

config.window_padding = {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
}

config.default_domain = "WSL:Ubuntu-22.04"

config.default_cursor_style = "BlinkingBar"
config.animation_fps = 60
config.cursor_blink_ease_in = "Constant"
config.cursor_blink_ease_out = "Constant"

config.window_close_confirmation = "NeverPrompt"

config.keys = {
	{ key = "F11", mods = "", action = wezterm.action.ToggleFullScreen },
	{ key = "F1", mods = "", action = wezterm.action.ActivateCommandPalette },
}

config.mouse_bindings = {
	{ event = { Up = { streak = 1, button = "Left" } }, mods = "CTRL", action = wezterm.action.OpenLinkAtMouseCursor },
}

local on_startup = function()
	-- attach tmux session on wezterm startup
	local attach_tmux_session = "tmux attach -t main || tmux new -s main\n"

	local _tab, pane, _window = mux.spawn_window({})
	pane:send_text(attach_tmux_session)
end

wezterm.on("gui-startup", on_startup)

-- and finally, return the configuration to wezterm
return config
