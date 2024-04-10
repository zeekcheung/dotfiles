local wezterm = require('wezterm')

local M = {}

function M.title(tab, max_width)
  -- local tab_id = tab.tab_id
  local tab_index = tab.tab_index
  local pane = tab.active_pane

  local process_name = pane.foreground_process_name
  local process = string.gsub(process_name, '(.*[/\\])(.*)', '%2')

  local title = wezterm.truncate_right(process, max_width - 3)
  return ' ' .. tab_index .. ':' .. title
end

function M.setup(config)
  config.use_fancy_tab_bar = false
  config.tab_bar_at_bottom = false
  config.hide_tab_bar_if_only_one_tab = true
  config.show_new_tab_button_in_tab_bar = false
  config.tab_max_width = 32
  config.unzoom_on_switch_pane = true
  config.colors = {
    tab_bar = {
      background = '#1b1b2b',
    },
  }

  wezterm.on('update-status', function(window, pane)
    local workspace = window:active_workspace()
    local hostname = wezterm.hostname()
    local date = wezterm.strftime('%Y-%m-%d %H:%M')

    window:set_left_status(wezterm.format({
      { Foreground = { Color = '#A6E3A1' } },
      { Text = '[' .. workspace .. ']' },
    }))

    window:set_right_status(wezterm.format({
      { Foreground = { Color = '#89B4FA' } },
      { Attribute = { Italic = true } },
      { Text = hostname .. ' ' .. date },
    }))
  end)

  wezterm.on('format-tab-title', function(tab, tabs, panes, config, hover, max_width)
    local title = M.title(tab, max_width)
    local colors = config.resolved_palette

    local res = {}

    if tab.is_active then
      res[#res + 1] = { Foreground = { Color = '#f38ba8' } }
    end
    res[#res + 1] = { Background = { Color = colors.tab_bar.background } }
    res[#res + 1] = { Text = title }

    return res
  end)
end

return M
