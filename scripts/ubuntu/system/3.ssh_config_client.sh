#!/bin/bash

# Prompt the user to enter their username on the server
read -p "Enter your username on the server: " username

# Create the .ssh directory if it doesn't exist
mkdir -p ~/.ssh

# Check if the client's public key is already in the authorized_keys file
if grep -q "$SSH_CLIENT" ~/.ssh/authorized_keys; then
    echo "Your public key is already in the authorized_keys file."
else
    # Prompt the user to create an SSH key pair if necessary
    echo "Please generate an SSH key pair on your local machine by running the following command:"
    echo "ssh-keygen -t rsa -b 4096 -C 'your_email@example.com'"
    echo "Then check the public key by running the following command:"
    echo "cat ~/.ssh/id_rsa.pub"
    echo "Finally, copy and paste the public key to the authorized_keys file on the server."

    # Prompt the user to enter their SSH public key
    read -p "Enter your SSH public key: " ssh_key
    # Add the SSH public key to the authorized_keys file
    echo "$ssh_key" >> ~/.ssh/authorized_keys

    # Set the correct permissions on the .ssh directory and authorized_keys file
    chmod 700 ~/.ssh
    chmod 600 ~/.ssh/authorized_keys
    chown -R $username:$username ~/.ssh

    # Output a message indicating that the SSH configuration is complete
    echo ""
    echo "SSH configuration is complete. You should now be able to connect to this server using SSH without a password."
fi
