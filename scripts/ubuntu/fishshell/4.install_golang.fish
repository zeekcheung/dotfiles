#!/usr/bin/env fish

# Download the Golang binary archive
curl -0 https://go.dev/dl/go1.21.0.linux-amd64.tar.gz

# Extract the archive to /usr/local
sudo tar -C /usr/local -xzf go1.21.0.linux-amd64.tar.gz

# Add Golang's binary directory to fish shell's path
echo 'set PATH $PATH /usr/local/go/bin' >> ~/.config/fish/config.fish
source ~/.config/fish/config.fish

# Verify the installation
go version
