#!/bin/bash

# Clone the source code
git clone --depth=1 https://github.com/alacritty/alacritty.git
cd alacritty || exit

# Install the Rust compiler with rustup
rustup override set stable
rustup update stable

# Install dependencies
sudo apt install cmake pkg-config libfreetype6-dev libfontconfig1-dev libxcb-xfixes0-dev libxkbcommon-dev python3

# Build
cargo build --release

# Terminfo
sudo tic -xe alacritty,alacritty-direct extra/alacritty.info

# Desktop entry
sudo cp target/release/alacritty /usr/local/bin # or anywhere else in $PATH
# sudo cp extra/logo/alacritty-term.svg /usr/share/pixmaps/Alacritty.svg
sudo cp ~/.config/alacritty/alacritty.svg /usr/share/pixmaps/Alacritty.svg
sudo desktop-file-install extra/linux/Alacritty.desktop
sudo update-desktop-database

# Remove the source code
cd ..
rm -rf alacritty
