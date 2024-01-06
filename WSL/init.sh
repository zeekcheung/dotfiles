# Install fish shell
sudo apt-add-repository ppa:fish-shell/release-3 -y
sudo apt update
sudo apt install fish -y

# Install fisher
/usr/bin/fish -c "curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher"

# Install oh-my-fish
curl https://raw.githubusercontent.com/oh-my-fish/oh-my-fish/master/bin/install

# Install starship
curl -sS https://starship.rs/install.sh | sh

# Install nvm
fisher install jorgebucaran/nvm.fish

# Install rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# Install golang
wget https://go.dev/dl/go1.21.0.linux-amd64.tar.gz
sudo tar -C /usr/local -xzf go1.21.0.linux-amd64.tar.gz

# Install lazygit
go install github.com/jesseduffield/lazygit@latest

# Install neovim
sudo add-apt-repository ppa:neovim-ppa/unstable -y
sudo apt update
sudo apt install neovim -y

# Install bat
sudo apt install bat -y

# Install gcc, g++, make
sudo apt install build-essential -y

# Install ripgrep
sudo apt install ripgrep -y

# Install fd
sudo apt install fd-find -y

# Install unzip
sudo apt install unzip -y

# Install lazyvim
# git clone git@github.com:zeekcheung/LazyVim_config.git ~/.config/nvim
