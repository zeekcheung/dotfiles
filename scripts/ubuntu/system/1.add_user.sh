#!/bin/bash

# Check if script is executed with sudo
if [ $(id -u) -ne 0 ]; then
    echo "Please run this script with sudo." >&2
    exit 1
fi

# Get username and password for the new user
read -p "Enter the username for the new user: " username
read -s -p "Enter the password for the new user: " password
echo ""

# Create the new user
adduser --gecos "" $username

# Set the password for the new user
echo "$username:$password" | chpasswd

# Ask if the new user should be granted sudo permissions
read -p "Grant $username sudo permissions? (y/n): " grant_sudo
if [ "$grant_sudo" = "y" ]; then
    usermod -aG sudo $username
    echo "User $username created and granted sudo permissions."
else
    echo "User $username created without sudo permissions."
fi

# Inform the user how to switch to the new user
echo "To switch to the new user, use the following command:"
echo "su - $username"
