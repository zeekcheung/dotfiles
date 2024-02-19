#!/bin/bash

# Clone my dotfiles
# git clone git@github.com:zeekcheung/dotfiles.git
# cp -R dotfiles/. ~/.config/

# Clone submodules
git submodule update --init

# Make symbolic links
ln -s ~/.config/.gitconfig ~/.gitconfig
ln -s ~/.config/tmux/.tmux.conf ~/.tmux.conf
ln -s ~/.config/vim/.vimrc ~/.vimrc
