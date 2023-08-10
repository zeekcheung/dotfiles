#!/bin/bash

# Install fish shell
sudo apt-add-repository ppa:fish-shell/release-3
sudo apt update
sudo apt install fish

# Set fish shell as the default shell
read -p "Do you want to set fish shell as the default shell? (y/n) " choice
if [[ "$choice" =~ ^[Yy]$ ]]; then
    chsh -s /usr/bin/fish
    cat <<EOT >>~/.config/fish/config.fish
# Fish
set -g fish_greeting ""
# Fish end
EOT
    echo "Fish shell has been set as the default shell."
else
    echo "Fish shell has not been set as the default shell."
fi

# Install fisher plugin manager
read -p "Do you want to install fisher plugin manager? (y/n) " fisher_choice
if [[ "$fisher_choice" =~ ^[Yy]$ ]]; then
    curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source &&
        fisher install jorgebucaran/fisher

    echo "fisher plugin manager has been installed."
    echo "Use \"fisher install author/plugin\" command to install plugins."
else
    echo "Fisher has not been installed."
fi

# Install Starship
read -p "Do you want to install Starship prompt? (y/n) " starship_choice
if [[ "$starship_choice" =~ ^[Yy]$ ]]; then
    curl -sS https://starship.rs/install.sh | sh
    cat <<EOT >>~/.config/fish/config.fish
# Starship
set -gx STARSHIP_CONFIG ~/.config/starship/config.toml
starship init fish | source
function fish_postcmd --on-event fish_postexec
    echo
end
# Starship end
EOT
    echo "Starship prompt has been installed."
else
    echo "Starship prompt has not been installed."
fi
