local wezterm = require 'wezterm'

local M = {}

---@type "default" | "powerline" | "tmux"
M.tab_bar_style = 'powerline'
M.tab_bar_bg = '#1e1e2e'

M.arrow_solid = ''
-- M.arrow_thin = ''
M.arrow_thin = ' '

M.palette = {
  red = '#eb6f92',
  green = '#3e8fb0',
  blue = '#9ccfd8',
  black = '#1e1e2e',
}

-- Convert hex to rgb
function M.hex_to_rgb(hex)
  hex = hex:gsub('#', '')
  return {
    tonumber(hex:sub(1, 2), 16),
    tonumber(hex:sub(3, 4), 16),
    tonumber(hex:sub(5, 6), 16),
  }
end

-- Setup left and right status
function M.setup_status()
  ---@diagnostic disable-next-line: unused-local
  wezterm.on('update-status', function(window, pane)
    local palette = M.palette
    local workspace = window:active_workspace()
    local hostname = wezterm.hostname()
    local date = wezterm.strftime '%Y-%m-%d %H:%M'

    local left_status = M.tab_bar_style == 'tmux'
        and {
          { Foreground = { Color = palette.green } },
          { Text = '[' .. workspace .. ']' },
        }
      or {}

    local right_status = {
      { Foreground = { Color = palette.blue } },
      { Attribute = { Italic = false } },
      { Text = hostname .. ' ' .. date },
    }

    window:set_left_status(wezterm.format(left_status))
    window:set_right_status(wezterm.format(right_status))
  end)
end

-- Fomat tab title
function M.tab_title(tab, tabs, max_width)
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

  local tab_title = ' ' .. tab_index + 1 .. ':' .. title
  if M.tab_bar_style == 'tmux' then
    tab_title = tab_title .. active_flag
  elseif M.tab_bar_style == 'powerline' then
    tab_title = tab_title .. ' '
  end

  return tab_title
end

-- Setup tab title
function M.setup_tab_title()
  if M.tab_bar_style == 'default' then
    return
  end

  ---@diagnostic disable-next-line: unused-local, redefined-local
  wezterm.on('format-tab-title', function(tab, tabs, panes, config, hover, max_width)
    local tab_title = M.tab_title(tab, tabs, max_width)
    local tab_index = 1
    for i, t in ipairs(tabs) do
      if t.tab_id == tab.tab_id then
        tab_index = i
        break
      end
    end
    local is_active = tab.is_active
    local is_last = tab_index == #tabs
    local next_tab = tabs[tab_index + 1]
    local next_is_active = next_tab and next_tab.is_active

    local palette = M.palette
    local tab_bar_bg = M.tab_bar_bg
    local colors = config.resolved_palette
    local active_tab_fg = colors.tab_bar.active_tab.fg_color
    local inactive_tab_fg = colors.tab_bar.inactive_tab.fg_color
    local active_tab_bg = colors.tab_bar.active_tab.bg_color
    local inactive_tab_bg = colors.tab_bar.inactive_tab.bg_color
    local inactive_tab_edge = colors.tab_bar.inactive_tab_edge

    -- Powerline style tab bar
    local function powerline_style_tab_bar()
      local res = {}

      local tab_title_fg = is_active and active_tab_fg or inactive_tab_fg
      local tab_title_bg = is_active and active_tab_bg or inactive_tab_bg

      local arrow = (is_active or is_last or next_is_active) and M.arrow_solid or M.arrow_thin
      local arrow_bg = inactive_tab_bg
      local arrow_fg = inactive_tab_edge

      if is_last then
        arrow_fg = is_active and active_tab_bg or inactive_tab_bg
        arrow_bg = tab_bar_bg
      elseif is_active then
        arrow_bg = inactive_tab_bg
        arrow_fg = active_tab_bg
      elseif next_is_active then
        arrow_bg = active_tab_bg
        arrow_fg = inactive_tab_bg
      end

      res = is_active
          and {
            -- { Attribute = { Intensity = 'Bold' } },
            -- { Attribute = { Italic = true } },
          }
        or {}
      res[#res + 1] = { Foreground = { Color = tab_title_fg } }
      res[#res + 1] = { Background = { Color = tab_title_bg } }
      res[#res + 1] = { Text = tab_title }
      res[#res + 1] = { Foreground = { Color = arrow_fg } }
      res[#res + 1] = { Background = { Color = arrow_bg } }
      res[#res + 1] = { Text = arrow }

      return res
    end

    -- Tmux style tab bar
    local function tmux_style_tab_bar()
      local res = {}
      active_tab_fg = palette.red
      inactive_tab_fg = 'white'

      res[#res + 1] = { Foreground = { Color = is_active and active_tab_fg or inactive_tab_fg } }
      res[#res + 1] = { Background = { Color = tab_bar_bg } }
      res[#res + 1] = { Text = tab_title }

      return res
    end

    -- Setup tab title
    if M.tab_bar_style == 'tmux' then
      return tmux_style_tab_bar()
    elseif M.tab_bar_style == 'powerline' then
      return powerline_style_tab_bar()
    end
  end)
end

function M.setup(config)
  local hex_to_rgb = M.hex_to_rgb
  local opacity = config.window_background_opacity
  local tab_bar_bg = M.tab_bar_bg

  config.use_fancy_tab_bar = false
  config.tab_bar_at_bottom = true
  config.hide_tab_bar_if_only_one_tab = true
  config.show_new_tab_button_in_tab_bar = false
  config.tab_max_width = 32
  config.unzoom_on_switch_pane = true
  config.colors = {
    tab_bar = {
      background = opacity ~= 1 and string.format('rgba(%s,%s)', table.concat(hex_to_rgb(tab_bar_bg), ','), 0.5)
        or tab_bar_bg,
    },
  }

  M.setup_status()
  M.setup_tab_title()
end

return M
