#!/bin/bash

# zsh
sudo apt install -y zsh
sudo chsh -s /usr/bin/zsh

git clone https://github.com/zsh-users/zsh-completions.git ~/.config/zsh/plugins/zsh-completions
git clone https://github.com/zsh-users/zsh-autosuggestions.git ~/.config/zsh/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.config/zsh/plugins/zsh-syntax-highlighting

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

# neovim
sudo add-apt-repository ppa:neovim-ppa/unstable -y
sudo apt update
sudo apt install -y neovim

# other tools
sudo apt install -y bat fd-find fzf ripgrep zoxide unzip xclip neofetch gnome-tweaks gnome-shell-extensions

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

# solaar
sudo add-apt-repository ppa:solaar-unifying/stable
sudo apt update
sudo apt install -y solaar
