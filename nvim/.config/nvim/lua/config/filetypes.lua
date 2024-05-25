-- Define some filetypes
vim.filetype.add {
  extension = {
    rasi = 'rasi',
    rofi = 'rasi',
    wofi = 'rasi',
  },
  filename = {
    ['.env'] = 'dotenv',
    ['vifmrc'] = 'vim',
  },
  pattern = {
    ['.*/waybar/config'] = 'jsonc',
    ['.*/mako/config'] = 'dosini',
    ['.*/hypr/.+%.conf'] = 'hyprlang',
    ['%.env%.[%w_.-]+'] = 'dotenv',
  },
}
