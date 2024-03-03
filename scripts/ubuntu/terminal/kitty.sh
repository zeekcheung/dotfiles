#!/bin/bash

# Install kitty nightly and dont launch it
curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin \
	installer=nightly launch=n

# Desktop integration
sudo ln -sf "$HOME"/.local/kitty.app/bin/* /usr/local/bin/
sudo ln -sf "$HOME"/.config/kitty/assets/kitty.desktop /usr/share/applications/kitty.desktop
sudo ln -sf "$HOME"/.config/kitty/assets/kitty.png /usr/share/pixmaps/kitty.png

# update desktop datebase
sudo update-desktop-database
