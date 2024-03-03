#!/bin/bash

# NOTE: This script must be run as root(pass `-u $USER` to prevent `sudo` changing `$USER`)
# `sudo -u $USER ./main.sh`

# Install dependencies
bash ./dependencies/main.sh

# Install terminal emulator
bash ./terminal/main.sh
