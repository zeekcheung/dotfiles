#!/bin/bash

sudo apt install -y zsh

if [ ! -d "$HOME/.oh-my-zsh" ]; then
	# Install oh-my-zsh if not exists
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

	# Install oh-my-zsh plugins
	git clone https://github.com/zsh-users/zsh-completions "${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}"/plugins/zsh-completions
	git clone https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}"/plugins/zsh-autosuggestions
	git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}"/plugins/zsh-syntax-highlighting

	# Create symbolic links
	ln -sf ~/.config/zsh/.zshrc ~/.zshrc
	ln -sf ~/.config/zsh/.zshenv ~/.zshenv

	# Set zsh as default shell
	bash -c "chsh -s $(which zsh)"
fi
