local M = {}

-- Smart resize window
--- @param direction "left"|"right"|"up"|"down"
--- @param size? number
function M.smart_resize_window(direction, size)
  local position = vim.api.nvim_win_get_position(0)
  local row, col = position[1], position[2]
  local in_top_left = row == 0 and col == 0
  local in_top_right = row == 0 and col ~= 0
  local in_bottom_left = row ~= 0 and col == 0
  local in_bottom_right = row ~= 0 and col ~= 0

  local to_left = direction == 'left'
  local to_right = direction == 'right'
  local to_up = direction == 'up'
  local to_down = direction == 'down'

  local width = vim.api.nvim_win_get_width(0)
  local height = vim.api.nvim_win_get_height(0)

  size = size or 1

  if
    (in_top_left and to_left)
    or (in_top_right and to_right)
    or (in_bottom_left and to_left)
    or (in_bottom_right and to_right)
  then
    vim.api.nvim_win_set_width(0, width - size)
  elseif
    (in_top_left and to_right)
    or (in_top_right and to_left)
    or (in_bottom_left and to_right)
    or (in_bottom_right and to_left)
  then
    vim.api.nvim_win_set_width(0, width + size)
  elseif
    (in_top_left and to_up)
    or (in_top_right and to_up)
    or (in_bottom_left and to_down)
    or (in_bottom_right and to_down)
  then
    vim.api.nvim_win_set_height(0, height - size)
  elseif
    (in_top_left and to_down)
    or (in_top_right and to_down)
    or (in_bottom_left and to_up)
    or (in_bottom_right and to_up)
  then
    vim.api.nvim_win_set_height(0, height + size)
  end
end

return M
