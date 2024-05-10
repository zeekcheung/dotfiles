#!/usr/bin/env bash

# shellcheck disable=SC1090,SC1091

# Make local directories
bash "$HOME/.dotfiles/bin/.local/bin/mkdir_local"

# Github dns
bash "$HOME/.dotfiles/bin/.local/bin/github520"

# Github proxy
ghproxy="https://mirror.ghproxy.com"

# Update and upgrade package sources
sudo apt update && sudo apt upgrade

# Essential tools
sudo apt install -y curl unzip stow \
	zsh tmux xsel \
	build-essential cmake \
	python3 python3-pip \
	luarocks \
	bat fd-find fzf ripgrep neofetch

# Neovim
nvim_version="0.9.5"
nvim_appimage_name="nvim.appimage"
nvim_appimage_server="https://github.com/neovim/neovim/releases/download/v$nvim_version"
wget "$ghproxy/$nvim_appimage_server/$nvim_appimage_name" -O "$HOME/.local/bin/nvim"
chmod +x "$HOME/.local/bin/nvim"

# n (nodejs)
n_prefix="$HOME/.n"
curl -L https://bit.ly/n-install | N_PREFIX=$n_prefix bash -s -- -y
ln -sf "$n_prefix/bin/node" "$HOME/.local/bin/node"
ln -sf "$n_prefix/bin/npm" "$HOME/.local/bin/npm"
ln -sf "$n_prefix/bin/npx" "$HOME/.local/bin/npx"

# Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source "$HOME/.cargo/env"
# cargo mirror
mkdir -vp "${CARGO_HOME:-$HOME/.cargo}"

cat <<EOF | tee -a "${CARGO_HOME:-$HOME/.cargo}"/config
[source.crates-io]
replace-with = 'ustc'

[source.ustc]
registry = "sparse+https://mirrors.ustc.edu.cn/crates.io-index/"
EOF

# Golang
go_version="1.22.2"
go_archive_name="go${go_version}.linux-amd64.tar.gz"
# go_archive_server="https://go.dev/dl"
go_archive_server="https://mirrors.ustc.edu.cn/golang/"

wget "${go_archive_server}/${go_archive_name}" -P /tmp
sudo tar -C /usr/local -xzf "/tmp/${go_archive_name}"
export PATH=/usr/local/go/bin:$HOME/go/bin:$PATH

# goproxy
export GO111MODULE=on
export GOPROXY=https://goproxy.cn

# lazygit
go install github.com/jesseduffield/lazygit@latest
ln -sf "$HOME/go/bin/lazygit" "$HOME/.local/bin/lazygit"

# bat is installed as batcat instead of bat on Debian/Ubuntu
ln -sf /usr/bin/batcat "$HOME"/.local/bin/bat

# zoxide
curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash

# eza
cargo install eza

# starship
curl -sS https://starship.rs/install.sh | sh

if grep -qi Microsoft /proc/version; then
	# WSL packages
	sudo apt install -y wslu xdg-utils
elif [ -n "$DESKTOP_SESSION" ]; then
	# Ubuntu desktop dependencies
	sudo apt install -y gnome-tweaks gnome-shell-extensions gnome-shell-extension-manager \
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

	bash "$HOME/.dotfiles/bin/.local/bin/install_fcitx5"

	# v2raya
	v2raya_version="2.2.5.1"
	v2raya_archive_name="installer_debian_x64_${v2raya_version}.deb"
	v2raya_archive_server="https://github.com/v2rayA/v2rayA/releases/download"
	wget "${ghproxy}/${v2raya_archive_server}/v${v2raya_version}/${v2raya_archive_name}" -P /tmp
	sudo dpkg -i /tmp/${v2raya_archive_name}

	# v2ray
	v2ray_version="5.14.1"
	v2ray_archive_name="v2ray_${v2ray_version}_amd64.deb"
	v2ray_archive_server="https://github.com/v2rayA/v2raya-apt/raw/master/pool/main/v/v2ray"
	wget "${ghproxy}/${v2ray_archive_server}/${v2ray_archive_name}" -P /tmp
	sudo dpkg -i /tmp/${v2ray_archive_name}

	sudo systemctl enable --now v2raya

	# dconf settings
	bash "$HOME/.dotfiles/bin/.local/bin/gnome_restore"
fi

# stow
bash "$HOME/.dotfiles/bin/.local/bin/stow_packages"

# desktop files
bash "$HOME/.dotfiles/bin/.local/bin/custom_desktop_files"
