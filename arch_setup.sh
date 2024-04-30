#!/usr/bin/env bash

# shellcheck disable=SC1091,SC2154

# make local directories
bash "$HOME/.dotfiles/bin/.local/bin/mkdir_local"

# set dns for github
bash "$HOME/.dotfiles/bin/.local/bin/github520"

pacman_conf="/etc/pacman.conf"

# add archlinuxcn package repository
archlinuxcn_name="archlinuxcn"
archlinuxcn_server="https://mirrors.tuna.tsinghua.edu.cn/archlinuxcn/\$arch"

if ! grep -q "\[${archlinuxcn_name}\]" "$pacman_conf"; then
	echo "Adding package repository ${archlinuxcn_name} to pacman.conf..."

	echo "[${archlinuxcn_name}]" | sudo tee -a "$pacman_conf" >/dev/null
	echo "Server = ${archlinuxcn_server}" | sudo tee -a "$pacman_conf" >/dev/null

	sudo pacman-key --lsign-key "farseerfc@archlinux.org"
	sudo pacman -Sy archlinuxcn-keyring --noconfirm
fi

# update and upgrade package sources
echo "Updating system..."
sudo pacman -Syyu --noconfirm

# install paru
echo "Installing paru..."
git clone --depth=1 https://aur.archlinux.org/paru.git /tmp/paru
cd /tmp/paru || return
makepkg -si

# install indispensable packages
packages_file="$HOME/.dotfiles/paru/.config/paru/packages.txt"
echo "Installing indispensable packages"
paru -S --needed - <"$packages_file"

# install fcitx5
bash "$HOME/.dotfiles/bin/.local/bin/install_fcitx5"

# stow packages
bash "$HOME/.dotfiles/bin/.local/bin/stow_packages"

# restore dconf settings in gnome
bash "$HOME/.dotfiles/bin/.local/bin/gnome_restore"

# enable system services for some packages
service_packages=(
	"gdm"
	"v2raya"
)

echo "Enabling some system service..."
for package in "${service_packages[@]}"; do
	if grep -q "$package" "$packages_file"; then
		sudo systemctl enable --now "$package.service"
	fi
done

# change some desktop file
echo "Changing desktop file for alacritty..."
cp "$HOME/.config/alacritty/assets/Alacritty.desktop" "$HOME/.local/share/applications"
cp "$HOME/.config/alacritty/assets/Alacritty.svg" "$HOME/.local/share/pixmaps"
sed -i "s|Icon=Alacritty|Icon=$HOME/.local/share/pixmaps/Alacritty.svg|g" "$HOME/.local/share/applications/Alacritty.desktop"

echo "Changing desktop file for kitty..."
cp "$HOME/.config/kitty/assets/kitty.desktop" "$HOME/.local/share/applications/kitty.desktop"
cp "$HOME/.config/kitty/assets/kitty.png" "$HOME/.local/share/pixmaps/kitty.png"
sed -i "s|Icon=kitty|Icon=$HOME/.local/share/pixmaps/kitty.png|g" "$HOME/.local/share/applications/kitty.desktop"
