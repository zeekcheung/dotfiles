#!/usr/bin/env bash

# shellcheck disable=SC1091,SC2154

# make local directories
bash "$HOME/.dotfiles/bin/.local/bin/mkdir_local"

# github dns
sudo bash -c 'sed -i "/# GitHub520 Host Start/Q" /etc/hosts && curl https://raw.hellogithub.com/hosts >> /etc/hosts'

# github proxy
ghproxy="https://mirror.ghproxy.com"

# update and upgrade package sources
sudo pacman -Syyu --noconfirm

# install paru
git clone --depth=1 ${ghproxy}/https://aur.archlinux.org/paru.git /tmp/paru
cd /tmp/paru || return
makepkg -si

# install indispensable packages
paru -S --needed - <"$HOME/.dotfiles/paru/.config/paru/packages.txt"

# install fcitx5
bash "$HOME/.dotfiles/bin/.local/bin/install_fcitx5"

# stow packages
bash "$HOME/.dotfiles/bin/.local/bin/stow_packages"

# restore dconf settings in gnome
bash "$HOME/.dotfiles/bin/.local/bin/gnome_restore"
