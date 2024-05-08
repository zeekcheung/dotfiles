#!/usr/bin/env python

# NOTE: This file is used to draw the tab bar in kitty.
# See [this discussion](https://github.com/kovidgoyal/kitty/discussions/4447) for examples from kitty users.

import datetime
import socket
from typing import Literal
from kitty.utils import color_as_int
from kitty.fast_data_types import Screen, get_options
from kitty.tab_bar import (
    DrawData, ExtraData, TabBarData, as_rgb,
    draw_tab_with_fade, draw_tab_with_slant,
    draw_tab_with_powerline, draw_tab_with_separator
)

# Kitty built-in tab styles
TabStyle = Literal["fade", "slant", "powerline", "separator"]

# Translate the kitty colors to rgb.
# Colors are defined in current-theme.conf.
# Get them with `get_options().colorX`.
def color_as_rgb(color):
    return as_rgb(color_as_int(color))

# Translate the hex color to rgb.
# hex is formatted as #RRGGBB.
def hex_as_rgb(hex: str):
    return as_rgb(int(hex[1:], 16))

# Tab bar background color
tab_bar_bg = hex_as_rgb("#1e1e2e")

# Draw the right status
def draw_right_status(screen: Screen, is_last: bool) -> int:
    if not is_last:
        return screen.cursor.x

    opts = get_options()

    # Right status colors
    right_status_fg = color_as_rgb(opts.color4)
    right_status_bg = tab_bar_bg

    # Right status components
    hostname = socket.gethostname()
    date = datetime.datetime.now().strftime(" %Y-%m-%d")
    time = datetime.datetime.now().strftime(" %H:%M")
    host_status = (right_status_fg, right_status_bg, hostname)
    date_status = (right_status_fg, right_status_bg, date)
    time_status = (right_status_fg, right_status_bg, time)

    cells = [host_status, date_status, time_status]

    right_status_length = 0
    for _, _, cell in cells:
        right_status_length += len(cell)

    draw_spaces = screen.columns - screen.cursor.x - right_status_length
    if draw_spaces > 0:
        screen.draw(" " * draw_spaces)

    for fg, bg, cell in cells:
        screen.cursor.fg = fg
        screen.cursor.bg = bg
        screen.draw(cell)
    screen.cursor.fg = 0
    screen.cursor.bg = 0

    screen.cursor.x = max(screen.cursor.x, screen.columns - right_status_length)
    return screen.cursor.x

# Draw the tab bar
def draw_tab(
    draw_data: DrawData, screen: Screen, tab: TabBarData,
    before: int, max_title_length: int, index: int, is_last: bool,
    extra_data: ExtraData,
) -> int:
    # Draw the left status.
    # See the functions named draw_tab_with_* in kitty’s source code:
    # [kitty/tab_bar.py](https://github.com/kovidgoyal/kitty/blob/master/kitty/tab_bar.py)
    def draw_left_status_with(style: TabStyle) -> int:
        draw_tab_with_style = "draw_tab_with_" + style

        if draw_tab_with_style in locals() and callable(locals()[draw_tab_with_style]):
            return locals()[draw_tab_with_style](
                draw_data, screen, tab, before, max_title_length, index, is_last, extra_data
            )
        elif draw_tab_with_style in globals() and callable(globals()[draw_tab_with_style]):
            return globals()[draw_tab_with_style](
                draw_data, screen, tab, before, max_title_length, index, is_last, extra_data
            )
        else:
            return 0


    end = draw_left_status_with("powerline")
    draw_right_status(screen, is_last)

    return end
