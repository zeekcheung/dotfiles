#!/bin/bash

# Clone my dotfiles
# git clone git@github.com:zeekcheung/dotfiles.git
# cp -R dotfiles/. ~/.config/

# Clone submodules
git submodule update --init

# Make symbolic links
ln -sf ~/.config/.gitconfig ~/.gitconfig
ln -sf ~/.config/tmux/.tmux.conf ~/.tmux.conf
ln -sf ~/.config/vim/.vimrc ~/.vimrc
