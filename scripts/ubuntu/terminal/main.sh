#!/bin/bash

# NOTE: This script must be run as root(pass `-u $USER` to prevent `sudo` changing `$USER`)
# `sudo -u $USER ./main.sh`

declare -A choice_terminal_map=(
	[1]="alacritty"
	[2]="kitty"
	[3]="wezterm"
)

# Ask to install which terminal
read -rp "Which terminal do you want to install? [1] alacritty, [2] kitty, [3] wezterm, [4] all: " choice

# Install selected terminal via script
if [ "$choice" == "4" ]; then
	for terminal in "${!choice_terminal_map[@]}"; do
		bash ./"${choice_terminal_map[$terminal]}".sh
	done

	# Ask which terminal should be set as default
	read -rp "Which terminal should be set as default? [1] alacritty, [2] kitty, [3] wezterm, [n] none: " choice
	if [[ $choice != "n" ]]; then
		terminal_name=${choice_terminal_map[$choice]}
	fi
else
	terminal_name=${choice_terminal_map[$choice]}
	bash ./"$terminal_name".sh

	read -rp "Do you want to set the terminal as default? [y/n]: " choice
fi

if [ "$choice" != "n" ]; then
	terminal_path=$(which "$terminal_name")

	sudo update-alternatives --install /usr/bin/x-terminal-emulator x-terminal-emulator "$terminal_path" 50
	sudo update-alternatives --config x-terminal-emulator

	bash ./open-in-terminal.sh "$terminal_name"
fi
