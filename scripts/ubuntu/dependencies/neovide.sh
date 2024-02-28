#!/bin/bash

# Install pre-requisites
sudo apt install -y curl \
	gnupg ca-certificates git \
	gcc-multilib g++-multilib cmake libssl-dev pkg-config \
	libfreetype6-dev libasound2-dev libexpat1-dev libxcb-composite0-dev \
	libbz2-dev libsndio-dev freeglut3-dev libxmu-dev libxi-dev libfontconfig1-dev \
	libxcursor-dev

# Install Rust if not exists
if [ ! -d "$HOME/.cargo" ]; then
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
fi

# Install neovide
cargo install --git https://github.com/neovide/neovide

# Install icon and desktop file
wget https://github.com/neovide/neovide/raw/main/assets/neovide.svg
sudo mv neovide.svg /usr/share/icons

wget https://github.com/neovide/neovide/blob/main/assets/neovide.desktop
sudo mv neovide.desktop /usr/share/applications
