#!/usr/bin/env bash

# shellcheck disable=SC1090,SC1091

# essential tools
sudo apt install -y zsh curl unzip \
	vim-gtk tmux \
	build-essential cmake \
	python3 python3-pip \
	bat fd-find fzf ripgrep neofetch

# neovim
sudo add-apt-repository ppa:neovim-ppa/stable -y
# sudo add-apt-repository ppa:neovim-ppa/unstable -y
sudo apt update
sudo apt install -y neovim

# n/nodejs
curl -L https://bit.ly/n-install | N_PREFIX="$HOME/.n" bash -s -- -y
sudo ln -sf "$HOME/n/bin/node" /usr/bin/node
sudo ln -sf "$HOME/n/bin/npm" /usr/bin/npm
sudo ln -sf "$HOME/n/bin/npx" /usr/bin/npx

# rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source "$HOME/.cargo/env"

# golang
wget https://go.dev/dl/go1.21.0.linux-amd64.tar.gz
sudo tar -C /usr/local -xzf go1.21.0.linux-amd64.tar.gz
rm go1.21.0.linux-amd64.tar.gz
export PATH=$HOME/go/bin:$PATH
source ~/.bashrc

# lazygit
go install github.com/jesseduffield/lazygit@latest
sudo ln -sf "$HOME/go/bin/lazygit" /usr/bin/lazygit

# bat is installed as batcat instead of bat on Debian/Ubuntu
ln -sf /usr/bin/batcat "$HOME"/.local/bin/bat

# zoxide
curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash

# eza
cargo install eza

# starship
curl -sS https://starship.rs/install.sh | sh

if grep -qi Microsoft /proc/version; then
	# WSL dependencies
	sudo apt install -y wslu xdg-utils
else
	# Ubuntu desktop dependencies
	sudo apt install -y gnome-tweaks gnome-shell-extensions gnome-browser-connector \
		libfreetype6-dev libfontconfig1-dev libxcb-xfixes0-dev libxkbcommon-dev pkg-config \
		gpick gimp

	# solaar
	sudo add-apt-repository ppa:solaar-unifying/stable
	sudo apt update
	sudo apt install -y solaar

	# fcitx5
	sudo apt install -y fcitx5 \
		fcitx5-chinese-addons \
		fcitx5-material-color \
		fcitx5-rime \
		fcitx5-table-emoji fcitx5-module-emoji \
		fcitx5-config-qt fcitx5-frontend-{gtk3,gtk4,qt5} \
		ruby

	install_fcitx5

	# v2raya
	wget https://github.com/v2rayA/v2rayA/releases/download/v2.2.4.7/installer_debian_x64_2.2.4.7.deb
	wget https://github.com/v2rayA/v2raya-apt/raw/master/pool/main/v/v2ray/v2ray_5.12.1_amd64.deb
	sudo dpkg -i installer_debian_x64_2.2.4.7.deb
	sudo dpkg -i v2ray_5.12.1_amd64.deb
	sudo systemctl start v2raya.service
	sudo systemctl enable v2raya.service
	rm installer_debian_x64_2.2.4.7.deb v2ray_5.12.1_amd64.deb
fi

stow_packages
