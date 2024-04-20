local wezterm = require('wezterm')

local M = {}

M.palette = {
  red = '#eb6f92',
  green = '#3e8fb0',
  blue = '#9ccfd8',
  black = '#1e1e2e',
}

function M.hex_to_rgb(hex)
  hex = hex:gsub('#', '')
  return {
    tonumber(hex:sub(1, 2), 16),
    tonumber(hex:sub(3, 4), 16),
    tonumber(hex:sub(5, 6), 16),
  }
end

function M.title(tab, tabs, max_width)
  -- local tab_id = tab.tab_id
  local tab_index = tab.tab_index
  local pane = tab.active_pane
  local is_active = tab.is_active

  local process_name = pane.foreground_process_name
  local process = string.gsub(process_name, '(.*[/\\])(.*)', '%2')
  local title = wezterm.truncate_right(process, max_width - 3)

  local active_tab_index = -1
  for _, t in ipairs(tabs) do
    if t.is_active then
      active_tab_index = t.tab_index
    end
  end
  local is_active_prev = (tab_index == active_tab_index - 1) or (active_tab_index == 0 and tab_index == #tabs - 1)
  local active_flag = is_active and '*' or (is_active_prev and '-' or ' ')

  return ' ' .. tab_index .. ':' .. title .. active_flag
end

function M.setup(config)
  local palette = M.palette
  local hex_to_rgb = M.hex_to_rgb
  local opacity = config.window_background_opacity

  config.use_fancy_tab_bar = false
  config.tab_bar_at_bottom = true
  config.hide_tab_bar_if_only_one_tab = true
  config.show_new_tab_button_in_tab_bar = false
  config.tab_max_width = 32
  config.unzoom_on_switch_pane = true
  config.colors = {
    tab_bar = {
      background = opacity ~= 1
        and string.format('rgba(%s,%s)', table.concat(hex_to_rgb(palette.black), ','), 0.5)
        or palette.black,
    },
  }

  wezterm.on('update-status', function(window, pane)
    local workspace = window:active_workspace()
    local hostname = wezterm.hostname()
    local date = wezterm.strftime('%Y-%m-%d %H:%M')

    window:set_left_status(wezterm.format({
      { Foreground = { Color = palette.green } },
      { Text = '[' .. workspace .. ']' },
    }))

    window:set_right_status(wezterm.format({
      { Foreground = { Color = palette.blue } },
      { Attribute = { Italic = false } },
      { Text = hostname .. ' ' .. date },
    }))
  end)

  wezterm.on('format-tab-title', function(tab, tabs, panes, config, hover, max_width)
    local title = M.title(tab, tabs, max_width)
    local colors = config.resolved_palette

    local res = {}

    res[#res + 1] = { Foreground = { Color = tab.is_active and palette.red or 'white' } }
    res[#res + 1] = { Background = { Color = colors.tab_bar.background } }
    res[#res + 1] = { Text = title }

    return res
  end)
end

return M
