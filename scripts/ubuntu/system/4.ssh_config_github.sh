#!/bin/bash

# Check if ssh-agent is running, otherwise start it
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_rsa

# Prompt the user to enter their GitHub email address
read -p "Enter your GitHub email address: " email

# Check if the user has set up their SSH key on GitHub
ssh -T git@github.com 2>&1 | grep "successfully authenticated" > /dev/null
if [ $? -eq 0 ]; then
    echo "SSH key is already set up on GitHub."
else
    echo "SSH key is not set up on GitHub. Setting up now..."
    ssh-keygen -t rsa -b 4096 -C $email
    ssh-add ~/.ssh/id_rsa
    echo ""
    echo "Your SSH public key is:"
    cat ~/.ssh/id_rsa.pub
    echo ""
    echo "Please copy and paste this key into your GitHub account settings."
fi
