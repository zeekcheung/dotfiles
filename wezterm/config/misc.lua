local wezterm = require("wezterm")

local M = {}

M.setup = function(config)
	config.front_end = "WebGpu"
	config.webgpu_power_preference = "HighPerformance"

	-- https://wezfurlong.org/wezterm/colorschemes/index.html
	-- config.color_scheme = "Rosé Pine (base16)"
	config.color_scheme = "Catppuccin Mocha"
	-- Custom colors
	config.colors = {
		tab_bar = {
			background = "#1e1e2e",
		},
	}

	-- Font
	config.font = wezterm.font_with_fallback({
		-- { family = "Maple Mono NF", weight = "Regular", italic = true },
		{ family = "JetBrainsMono Nerd Font", weight = "Regular", italic = false },
		{ family = "Terminus", weight = "Regular" },
	})
	config.font_size = 16

	-- Dimensions
	config.initial_cols = 80
	config.initial_rows = 20

	-- Padding
	config.window_padding = { left = 0, right = 0, top = 0, bottom = 0 }

	-- Window title bar
	config.window_frame = {
		font_size = 12,
		active_titlebar_bg = "#181825",
		inactive_titlebar_bg = "#11111b",
	}

	config.animation_fps = 60

	-- Cursor
	config.default_cursor_style = "BlinkingBlock"
	-- config.cursor_blink_ease_in = "Constant"
	-- config.cursor_blink_ease_out = "Constant"

	-- Command palette
	config.command_palette_rows = 8
	config.command_palette_bg_color = "#1e1e2e"
	config.command_palette_fg_color = "#bbbbbb"
	config.command_palette_font_size = 16

	config.window_close_confirmation = "NeverPrompt"

	-- https://wezfurlong.org/wezterm/recipes/workspaces.html
	-- Wezterm workspaces -> Tmux sessions
	-- Wezterm tabs -> Tmux windows
	-- Wezterm panes -> Tmux panes
	config.default_workspace = "main"

	local is_linux = wezterm.target_triple:find("linux")
	local is_windows = wezterm.target_triple:find("windows")

	if is_linux then
		config.integrated_title_button_style = "Gnome"
	end

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
end

return M
