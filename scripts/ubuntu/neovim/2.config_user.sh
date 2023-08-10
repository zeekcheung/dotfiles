#!/bin/bash

# Make a backup of current nvim and shared folder
mv ~/.config/nvim ~/.config/nvim.bak
mv ~/.local/share/nvim ~/.local/share/nvim.bak

# Clone AstroNvim
git clone https://github.com/AstroNvim/AstroNvim ~/.config/nvim

# Clone my AstroNvim user configuration
git clone git@github.com:zeekcheung/nvim_config.git ~/.config/nvim/lua/user

# Start Neovim
nvim
