local wezterm = require 'wezterm'

local M = {}

function M.setup(config)
  -- Environment variables
  config.term = 'wezterm'

  config.front_end = 'WebGpu'
  config.webgpu_power_preference = 'HighPerformance'

  -- Colorscheme
  config.color_scheme = 'rose-pine-moon'
  wezterm.add_to_config_reload_watch_list(config.color_scheme .. '.toml')

  -- Opacity
  -- config.window_background_opacity = 0.90

  -- Font
  config.font = wezterm.font_with_fallback {
    { family = 'Maple Mono NF', weight = 'Regular', italic = false },
    { family = 'JetBrains Mono', weight = 'Regular', italic = false },
  }
  config.font_size = 18
  config.freetype_load_flags = 'NO_HINTING'
  -- config.underline_thickness = '200%'

  -- Dimensions
  config.initial_cols = 80
  config.initial_rows = 20

  -- Padding
  config.window_padding = { left = 0, right = 0, top = 0, bottom = 0 }

  -- Window title bar
  config.window_frame = {
    font_size = 12,
    active_titlebar_bg = '#181825',
    inactive_titlebar_bg = '#11111b',
  }

  -- Format window title
  ---@diagnostic disable-next-line: unused-local, redefined-local
  wezterm.on('format-window-title', function(tab, pane, tabs, panes, config)
    return tab.active_pane.title
  end)

  config.animation_fps = 60

  -- Cursor
  config.default_cursor_style = 'BlinkingBlock'
  -- config.cursor_blink_ease_in = "EaseIn"
  -- config.cursor_blink_ease_out = "EaseOut"

  -- Bell
  config.audible_bell = 'Disabled'

  -- Command palette
  config.command_palette_rows = 8
  config.command_palette_bg_color = '#1b1b2b'
  config.command_palette_fg_color = '#a9b1d6'
  config.command_palette_font_size = 16

  config.window_close_confirmation = 'NeverPrompt'

  -- https://wezfurlong.org/wezterm/recipes/workspaces.html
  -- Wezterm workspaces -> Tmux sessions
  -- Wezterm tabs -> Tmux windows
  -- Wezterm panes -> Tmux panes
  config.default_workspace = 'main'

  local is_linux = wezterm.target_triple:find 'linux'
  local is_windows = wezterm.target_triple:find 'windows'

  if is_linux then
    config.integrated_title_button_style = 'Gnome'
  end

  if is_windows then
    -- Windows shell
    -- config.default_prog = { "pwsh", "-nologo" }
    config.default_prog = { 'nu' }
    -- WSL
    -- config.default_domain = "WSL:Ubuntu-22.04"

    config.launch_menu = {
      { label = 'PowerShell', args = { 'pwsh', '-nologo' } },
      { label = 'Ubuntu-22.04', args = { 'wsl', '~' } },
      { label = 'cmd', args = { 'cmd', '/k' } },
    }

    -- Change scale to 125%: 96 * 1.25 = 120
    config.dpi = 120
  end
end

return M
