#!/bin/bash

terminal_name=$1

# Default terminal is alacritty
if [ "$terminal_name" == "" ]; then
	echo "Using default terminal: alacritty"
	terminal_name="alacritty"
fi

# If terminal is not installed, install it
if ! command -v "$terminal_name" &>/dev/null; then
	echo "$terminal_name not found. Installing..."
	bash ./"$terminal_name".sh
fi

# Install nautilus and nautilus-open-any-terminal
sudo apt install -y python3-nautilus
pip install --user nautilus-open-any-terminal

# Quit Nautilus
nautilus -q

glib-compile-schemas ~/.local/share/glib-2.0/schemas/

# Add 'Open in Terminal' option with the selected terminal
gsettings set com.github.stunkymonkey.nautilus-open-any-terminal terminal "$terminal_name"
gsettings set com.github.stunkymonkey.nautilus-open-any-terminal new-tab true

# Remove the built-in 'Open in Terminal' option
sudo apt remove nautilus-extension-gnome-terminal

echo "$terminal_name is now set as default terminal in Nautilus"
