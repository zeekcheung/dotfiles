#!/bin/bash

# shellcheck disable=SC1090,SC1091

# zsh
bash ./zsh.sh

# starship
curl -sS https://starship.rs/install.sh | sh

# nvm
# curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
#
# export NVM_DIR="$HOME/.nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion
#
# # nodejs
# nvm install --lts
# nvm use --lts

# n/nodejs
curl -L https://bit.ly/n-install | bash

# c/c++
sudo apt install -y build-essential

# rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

source "$HOME/.cargo/env"

# golang
wget https://go.dev/dl/go1.21.0.linux-amd64.tar.gz
sudo tar -C /usr/local -xzf go1.21.0.linux-amd64.tar.gz
rm go1.21.0.linux-amd64.tar.gz

export PATH=$PATH:/usr/local/go/bin
source ~/.bashrc

# lazygit
go install github.com/jesseduffield/lazygit@latest

# lf
env CGO_ENABLED=0 go install -ldflags="-s -w" github.com/gokcehan/lf@latest

# neovim
sudo add-apt-repository ppa:neovim-ppa/unstable -y
sudo apt update
sudo apt install -y neovim

# other tools
sudo apt install -y bat curl fd-find fzf neofetch python3-pip ripgrep tmux unzip xclip vim-gtk

# bat is installed as batcat instead of bat on Debian/Ubuntu
ln -s /usr/bin/batcat ~/.local/bin/bat

# zoxide
curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash

# eza
cargo install eza

# bottom
curl -LO https://github.com/ClementTsang/bottom/releases/download/0.9.6/bottom_0.9.6_amd64.deb
sudo dpkg -i bottom_0.9.6_amd64.deb
rm bottom_0.9.6_amd64.deb

if grep -qi Microsoft /proc/version; then
	# WSL dependencies
	sudo apt install -y wslu xdg-utils
else
	# Ubuntu desktop dependencies
	sudo apt install -y gimp gpick gnome-shell-extensions gnome-tweaks

	# solaar
	sudo add-apt-repository ppa:solaar-unifying/stable
	sudo apt update
	sudo apt install -y solaar

	# fcitx5
	bash ./fcitx5.sh

	# fonts
	bash ./fonts.sh

	# v2raya
	bash ./v2raya.sh

	# neovide
	bash ./neovide.sh
fi

# Use my config
bash ./config.sh
