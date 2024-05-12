local wezterm = require 'wezterm'
local act = wezterm.action

local M = {}

function M.setup(config)
  config.mouse_bindings = {
    -- Bind 'Up' event of CTRL-Click to open hyperlinks
    { event = { Up = { streak = 1, button = 'Left' } }, mods = 'CTRL', action = act.OpenLinkAtMouseCursor },
    -- Disable the 'Down' event of CTRL-Click to avoid weird program behaviors
    { event = { Down = { streak = 1, button = 'Left' } }, mods = 'CTRL', action = act.Nop },
    -- Right click to paste from clipboard
    {
      event = { Down = { streak = 1, button = 'Right' } },
      mods = 'NONE',
      action = wezterm.action_callback(function(window, pane)
        local has_selection = window:get_selection_text_for_pane(pane) ~= ''
        if has_selection then
          window:perform_action(act.CopyTo 'ClipboardAndPrimarySelection', pane)
          window:perform_action(act.ClearSelection, pane)
        else
          window:perform_action(act { PasteFrom = 'Clipboard' }, pane)
        end
      end),
    },
  }
end

return M
