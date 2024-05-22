if not vim.g.neovide then
  return
end

-- disable mini.aniate
vim.g.mini_animate = false

-- font
vim.o.guifont = 'Maple Mono NF:h18'

-- background color
vim.g.neovide_background_color = '#232136'
vim.g.transparent_background = false

-- floating shadow
-- FIXME: Drop shadow causes incorrect rendering of float border
-- See: https://github.com/neovide/neovide/issues/2113
vim.g.neovide_floating_shadow = false

-- misc
vim.g.neovide_hide_mouse_when_typing = true
vim.g.neovide_cursor_vfx_mode = 'railgun'

-- keymaps
local map = vim.keymap.set

map('v', '<C-S-c>', '"+y', { desc = 'Copy' })
map('v', '<C-S-x>', '"+d', { desc = 'Cut' })
map({ 'i', 'c' }, '<C-S-v>', '<C-r>+', { desc = 'Paste' })
map('t', '<C-S-v>', '<C-\\><C-N>"+pi', { noremap = true, silent = true })

map('n', '<F11>', function()
  vim.g.neovide_fullscreen = not vim.g.neovide_fullscreen
end, { desc = 'Toggle full screen' });

-- stylua: ignore
(function()
  local change_scale_factor = function(delta)
    vim.g.neovide_scale_factor = vim.g.neovide_scale_factor * delta
  end
  map('n', '<C-=>', function() change_scale_factor(1.25) end, { desc = 'Zoom in' })
  map('n', '<C-->', function() change_scale_factor(1 / 1.25) end, { desc = 'Zoom out' })
end)()
