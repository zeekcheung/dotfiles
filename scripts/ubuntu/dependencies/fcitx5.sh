#!/bin/bash

# Install dependencies
sudo apt update
sudo apt install -y fcitx5 \
	fcitx5-chinese-addons \
	fcitx5-material-color \
	fcitx5-rime \
	fcitx5-table-emoji fcitx5-module-emoji \
	fcitx5-config-qt fcitx5-frontend-{gtk3,gtk4,qt5}

# Change then environment variables on Pop!_OS
if grep -qi pop /proc/version; then
	sudo tee /etc/profile.d/z-pop-os-fcitx.sh <<'EOF'
export GTK_IM_MODULE=""
export QT_IM_MODULE=""
export XMODIFIERS=""
EOF
fi

# Set fcitx5 as the default input method for current user
im-config -n fcitx5

# Install rime-rice
sudo apt install ruby

git clone --depth=1 https://github.com/Mark24Code/rime-auto-deploy.git --branch latest

cd rime-auto-deploy || exit

chmod +x ./installer.rb

./installer.rb

# Remove tmp dir
cd ../
rm -rf rime-auto-deploy

# Make symbolic links for custom config
ln -sf ~/.config/fcitx5/rime/default.custom.yaml ~/.local/share/fcitx5/rime/default.custom.yaml
ln -sf ~/.config/fcitx5/rime/rime_ice.custom.yaml ~/.local/share/fcitx5/rime/rime_ice.custom.yaml
