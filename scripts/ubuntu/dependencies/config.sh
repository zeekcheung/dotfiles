#!/bin/bash

# Clone my dotfiles
# git clone git@github.com:zeekcheung/dotfiles.git
# cp -R dotfiles/. ~/.config/

# Make symbolic links
ln -sf ~/.config/.gitconfig ~/.gitconfig
ln -sf ~/.config/tmux/.tmux.conf ~/.tmux.conf
ln -sf ~/.config/vim/.vimrc ~/.vimrc
