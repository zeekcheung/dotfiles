#!/bin/bash

# Add the unstable neovim PPA repository
sudo add-apt-repository ppa:neovim-ppa/unstable

# Update the package list and install neovim
sudo apt-get update
sudo apt-get install neovim

# Print the installed neovim version
nvim --version
