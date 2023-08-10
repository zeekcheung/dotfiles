#!/bin/bash

# Check if script is executed with sudo
if [ $(id -u) -ne 0 ]; then
    echo "Please run this script with sudo." >&2
    exit 1
fi

# Add an entry to the sudoers file to allow the current user to execute sudo without a password
echo "$(whoami) ALL=(ALL) NOPASSWD: ALL" | sudo tee -a /etc/sudoers.d/$(whoami)
