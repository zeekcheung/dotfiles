#!/usr/bin/env bash

# shellcheck disable=SC1091,SC2154

DESKTOP_ENVIRONMENT="gnome_minimal" # "gnome" | "gnome_minimal" | "kde"
INPUT_METHOD="fcitx5"

BASE_PACKAGES=(
	"sof-firmware" "alsa-firmware" "alsa-ucm-conf"         # Audio firmware
	"bluez" "bluez-utils" "bluez-obex"                     # Bluetooth
	"ntfs-3g"                                              # ntfs support
	"adobe-source-han-serif-cn-fonts" "wqy-zenhei"         # Chinese fonts
	"noto-fonts-cjk" "noto-fonts-emoji" "noto-fonts-extra" # Emoji and extra fonts
	"firefox" "chromium"                                   # Browsers
	"git" "wget" "curl"                                    # network tools
)

EXTRA_PACKAGES=(
	"alacritty" "kitty" "wezterm"                                              # Terminal Emulators
	"zsh" "fish" "man-db"                                                      # Shell
	"eza" "fd" "ripgrep" "starship" "yazi" "zoxide" "fastfetch" "stow"         # Terminal tools
	"neovim" "tmux" "xsel"                                                     # Editor
	"clang" "cmake" "make" "go" "lua" "luarocks" "nodejs" "yarn" "ruby" "rust" # Languages
	"rofi" "solaar" "spotify-launcher" "v2raya"                                # Desktop apps
	"bibata-cursor-theme" "papirus-icon-theme" "pop-icon-theme"                # Desktop themes
)

echo "=== Starting Arch Linux setup ==="

# Make local directories
bash "$HOME/.dotfiles/bin/.local/bin/mkdir_local"

# Set dns for github
bash "$HOME/.dotfiles/bin/.local/bin/github520"

pacman_conf="/etc/pacman.conf"

# Add archlinuxcn package repository
archlinuxcn_name="archlinuxcn"
archlinuxcn_server="https://mirrors.tuna.tsinghua.edu.cn/archlinuxcn/\$arch"

if ! grep -q "\[${archlinuxcn_name}\]" "$pacman_conf"; then
	echo "Adding package repository ${archlinuxcn_name} to pacman.conf..."

	echo "[${archlinuxcn_name}]" | sudo tee -a "$pacman_conf" >/dev/null
	echo "Server = ${archlinuxcn_server}" | sudo tee -a "$pacman_conf" >/dev/null

	sudo pacman-key --lsign-key "farseerfc@archlinux.org"
	sudo pacman -Sy archlinuxcn-keyring --noconfirm
fi

# Update and upgrade package sources
echo "Updating system..."
sudo pacman -Syyu --noconfirm

# Config mirrors for cargo
mkdir -vp "${CARGO_HOME:-$HOME/.cargo}"

cat <<EOF | tee -a "${CARGO_HOME:-$HOME/.cargo}"/config
[source.crates-io]
replace-with = 'ustc'

[source.ustc]
registry = "sparse+https://mirrors.ustc.edu.cn/crates.io-index/"
EOF

# Install base packages with pacman
echo "Installing base packages..."
sudo pacman -S --needed --noconfirm "${BASE_PACKAGES[@]}"

# Install paru
echo "Installing paru..."
git clone --depth=1 https://aur.archlinux.org/paru.git /tmp/paru
cd /tmp/paru || return
makepkg -si

# Install extra packages with paru
echo "Installing extra packages..."
paru -S --needed --noconfirm "${EXTRA_PACKAGES[@]}"

# Install desktop environment
if grep -qi "gnome" "$DESKTOP_ENVIRONMENT"; then
	if [ "$DESKTOP_ENVIRONMENT" = "gnome_minimal" ]; then
		# Install minimal gnome
		paru -S --needed --noconfirm \
			gnome-shell gnome-control-center gnome-keyring nautilus
	elif [ "$DESKTOP_ENVIRONMENT" = "gnome" ]; then
		# Install full gnome
		paru -S --needed --noconfirm gnome
	fi
	# Install other gnome packages
	paru -S --needed --noconfirm \
		gdm gnome-tweaks gnome-shell-extensions power-profiles-daemon \
		gnome-shell-extension-dash-to-dock gnome-shell-extension-forge-git \
		catppuccin-gtk-theme-macchiato

	# Enable systemd service
	sudo systemctl enable gdm
	sudo systemctl enable power-profiles-daemon

	# Restore dconf settings in gnome
	bash "$HOME/.dotfiles/bin/.local/bin/dconf_restore"
elif [ "$DESKTOP_ENVIRONMENT" = "kde" ]; then
	# Install kde
	paru -S --needed --noconfirm \
		plasma-meta sddm dolphin ark \
		p7zip unrar unarchiver lzop lrzip \
		packagekit-qt5 packagekit appstream-qt appstream \
		gwenview kate bind

	# Enable systemd service
	sudo systemctl enable sddm
fi

# Install input method
if [ "$INPUT_METHOD" = "fcitx5" ]; then
	# Install fcitx5
	paru -S --needed --noconfirm \
		fcitx5-im fcitx5-rime fcitx5-chinese-addons fcitx5-material-color fcitx5-pinyin-zhwiki

	bash "$HOME/.dotfiles/bin/.local/bin/install_fcitx5"
fi

# Stow packages
bash "$HOME/.dotfiles/bin/.local/bin/stow_packages"

# Enable system services
echo "Enabling some system service..."
sudo systemctl enable v2raya
sudo systemctl enable bluetooth

# Finish
echo "=== Arch Linux setup finished ==="
echo "Please reboot your computer."
