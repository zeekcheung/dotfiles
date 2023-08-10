#!/bin/bash

# Prompt the user to enter the Git username and email
read -p "Enter your Git username: " username
read -p "Enter your Git email: " email
echo ""

# Set the Git global username and email
git config --global user.name "$username"
git config --global user.email "$email"

# Output the current Git global configuration
echo ""
echo "The current Git global configuration is as follows:"
git config --global --list | grep user
