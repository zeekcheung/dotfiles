#!/bin/bash

# zsh
sudo apt install -y zsh

# oh-my-zsh
ZSH="$HOME/.config/oh-my-zsh"
ZSH_CUSTOM="$ZSH/custom"

# zsh plugins
git clone https://github.com/zsh-users/zsh-completions "$ZSH_CUSTOM/plugins/zsh-completions"
git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"

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

# lf
env CGO_ENABLED=0 go install -ldflags="-s -w" github.com/gokcehan/lf@latest

# neovim
sudo add-apt-repository ppa:neovim-ppa/unstable -y
sudo apt update
sudo apt install -y neovim

# other tools
sudo apt install -y bat fd-find fzf neofetch python3-pip ripgrep unzip xclip vim-gtk

# zoxide
curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash

# eza
sudo mkdir -p /etc/apt/keyrings
wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list
sudo apt update
sudo apt install -y eza

# bottom
curl -LO https://github.com/ClementTsang/bottom/releases/download/0.9.6/bottom_0.9.6_amd64.deb
sudo dpkg -i bottom_0.9.6_amd64.deb
rm bottom_0.9.6_amd64.deb

if grep -qi Microsoft /proc/version; then
	# WSL dependencies
	sudo apt install -y wslu xdg-utils
else
	# Ubuntu desktop dependencies
	sudo apt install -y gimp gnome-shell-extensions gnome-tweaks

	sudo apt install -y python3-nautilus
	pip3 install --user nautilus-open-any-terminal --break-system-packages

	# solaar
	sudo add-apt-repository ppa:solaar-unifying/stable
	sudo apt update
	sudo apt install -y solaar

	# rime
	bash ./fcitx5.sh
fi

# Install oh-my-zsh at the end to prevent the script from being terminated
wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh
ZSH=$ZSH sh install.sh
