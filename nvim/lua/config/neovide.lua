if not vim.g.neovide then
  return
end

-- font
vim.o.guifont = 'JetBrainsMono Nerd Font:h18'
vim.g.neovide_scale_factor = 1.0
-- padding
vim.g.neovide_padding_top = 0
vim.g.neovide_padding_bottom = 0
vim.g.neovide_padding_right = 0
vim.g.neovide_padding_left = 0
-- floating shadow
-- FIX: Drop shadow causes incorrect rendering of float border
-- See: https://github.com/neovide/neovide/issues/2113
vim.g.neovide_floating_shadow = true
vim.g.neovide_floating_z_height = 10
vim.g.neovide_light_angle_degrees = 45
vim.g.neovide_light_radius = 5
-- background color
vim.g.neovide_transparency = 1.0
vim.g.transparent_background = vim.g.neovide_transparency ~= 1.0
-- -- scroll animation length
-- vim.g.neovide_scroll_animation_length = 0.3
-- hiding the mouse when typing
vim.g.neovide_hide_mouse_when_typing = true
-- underline automatic scaling
vim.neovide_underline_automatic_scaling = false
-- theme
vim.g.neovide_theme = 'auto'
-- refresh rate
vim.g.neovide_refresh_rate = 60
-- idle refresh rate
vim.g.neovide_refresh_rate_idle = 5
-- no idle
vim.g.neovide_no_idle = true
-- confirm quit
vim.g.neovide_confirm_quit = true
-- full screen
vim.g.neovide_fullscreen = false
-- remember previous windows size
vim.g.neovide_remember_window_size = true
-- profiler
vim.g.neovide_profiler = false
-- -- animation length
-- vim.g.neovide_cursor_animation_length = 0.13
-- -- animation trail size
vim.g.neovide_cursor_trail_size = 0
-- -- antialiasing
-- vim.g.neovide_cursor_antialiasing = true
-- -- animate in insert mode
-- vim.g.neovide_cursor_animate_in_insert_mode = true
-- cursor particles
vim.g.neovide_cursor_vfx_mode = 'railgun'
-- -- particle opacity
-- vim.g.neovide_cursor_vfx_opacity = 200.0
-- -- particle lifetime
-- vim.g.neovide_cursor_vfx_lifetime = 1.2
-- -- particle density
-- vim.g.neovide_cursor_vfx_particle_density = 7.0
-- -- particle speed
-- vim.g.neovide_cursor_vfx_speed = 10.0
-- -- particle phase
-- vim.g.neovide_cursor_vfx_phase = 1.5
-- -- particle curl
-- vim.g.neovide_cursor_vfx_particle_curl = 1.0

local map = vim.keymap.set

map('v', '<C-S-c>', '"+y', { desc = 'Copy' })
map('v', '<C-S-x>', '"+d', { desc = 'Cut' })
map('i', '<C-S-v>', '<C-r>+', { desc = 'Paste' })

map('n', '<F11>', function()
  vim.g.neovide_fullscreen = not vim.g.neovide_fullscreen
end, { desc = 'Toggle full screen' });

-- stylua: ignore
(function()
  local change_scale_factor = function(delta)
    vim.g.neovide_scale_factor = vim.g.neovide_scale_factor * delta
  end
  map('n', '<C-=>', function() change_scale_factor(1.25) end, {desc = 'Zoom in'})
  map('n', '<C-->', function() change_scale_factor(1 / 1.25) end, {desc = 'Zoom out'})
end)()
