#!/bin/bash

# Change ubuntu sources to tsinghua sources
change_sources() {
	# Backup the original sources.list
	sudo cp /etc/apt/sources.list /etc/apt/sources.list.backup

	# Change the sources.list
	sudo tee /etc/apt/sources.list >/dev/null <<EOL
# 默认注释了源码镜像以提高 apt update 速度，如有需要可自行取消注释
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ lunar main restricted universe multiverse
# deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ lunar main restricted universe multiverse
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ lunar-updates main restricted universe multiverse
# deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ lunar-updates main restricted universe multiverse
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ lunar-backports main restricted universe multiverse
# deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ lunar-backports main restricted universe multiverse

deb http://security.ubuntu.com/ubuntu/ lunar-security main restricted universe multiverse
# deb-src http://security.ubuntu.com/ubuntu/ lunar-security main restricted universe multiverse

# 预发布软件源，不建议启用
# deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ lunar-proposed main restricted universe multiverse
# # deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ lunar-proposed main restricted universe multiverse
EOL

	# Update the sources
	sudo apt update
}

# Install dependencies
install_deps() {
	# zsh
	sudo apt install -y zsh
	sudo chsh -s /usr/bin/zsh

	# starship
	curl -sS https://starship.rs/install.sh | sh

	# nvm
	curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash

	# c/c++
	sudo apt install -y build-essential

	# rust
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

	# golang
	wget https://go.dev/dl/go1.21.0.linux-amd64.tar.gz
	sudo tar -C /usr/local -xzf go1.21.0.linux-amd64.tar.gz
	rm go1.21.0.linux-amd64.tar.gz

	# lazygit
	go install github.com/jesseduffield/lazygit@latest

	# neovim
	sudo add-apt-repository ppa:neovim-ppa/unstable -y
	sudo apt update
	sudo apt install -y neovim

	# other tools
	sudo apt install -y bat fd-find fzf ripgrep zoxide unzip neofetch

	# eza
	sudo mkdir -p /etc/apt/keyrings
	wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
	echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list
	sudo apt update
	sudo apt install -y eza

	# bottom
	curl -LO https://github.com/ClementTsang/bottom/releases/download/0.9.6/bottom_0.9.6_amd64.deb
	rm bottom_0.9.6_amd64.deb
	sudo dpkg -i bottom_0.9.6_amd64.deb
}

config() {
	# Clone my dotfiles
	git clone git@github.com:zeekcheung/dotfiles.git ~/.config

	# Make symbolic links
	ln -s ~/.config/.gitconfig ~/.gitconfig
	ln -s ~/.config/zsh/.zshrc ~/.zshrc
	ln -s ~/.config/zsh/.zshenv ~/.zshenv
	ln -s ~/.config/tmux/.tmux.conf ~/.tmux.conf
	ln -s ~/.config/vim/.vimrc ~/.vimrc
}

change_sources
install_deps
config
