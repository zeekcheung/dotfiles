#!/usr/bin/env fish

# Install Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# Add Rust's binary directory to fish shell's path
if [[ -d "$HOME/.cargo/bin" ]]; then
  echo 'set PATH $HOME/.cargo/bin $PATH' >> ~/.config/fish/config.fish
  echo 'Rust has been installed and the PATH has been added to fish shell'
else
  echo 'Rust installation failed or the binary directory does not exist'
fi

source ~/.config/fish/config.fish

# Verify the installation
rustc --version
