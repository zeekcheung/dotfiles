#!/usr/bin/env fish

# Install nvm with fisher
fisher install jorgebucaran/nvm.fish

source ~/.config/fish/config.fish

# Verify the installation
nvm -v
