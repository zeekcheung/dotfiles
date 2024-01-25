#!/bin/bash

# Clone my dotfiles
# git clone git@github.com:zeekcheung/dotfiles.git
# cp dotfiles/* -r ~/.config

# Clone submodules
git submodule update --init

# Make symbolic links
ln -s ~/.config/.gitconfig ~/.gitconfig
ln -s ~/.config/zsh/.zshrc ~/.zshrc
ln -s ~/.config/zsh/.zshenv ~/.zshenv
ln -s ~/.config/tmux/.tmux.conf ~/.tmux.conf
ln -s ~/.config/vim/.vimrc ~/.vimrc
