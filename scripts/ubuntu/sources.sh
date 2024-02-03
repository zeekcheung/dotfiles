#!/bin/bash

# Backup the original sources.list
sudo cp /etc/apt/sources.list /etc/apt/sources.list.backup

# Change the sources.list
sudo tee /etc/apt/sources.list >/dev/null <<EOL
# 默认注释了源码镜像以提高 apt update 速度，如有需要可自行取消注释
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ lunar main restricted universe multiverse
# deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ lunar main restricted universe multiverse
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ lunar-updates main restricted universe multiverse
# deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ lunar-updates main restricted universe multiverse
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ lunar-backports main restricted universe multiverse
# deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ lunar-backports main restricted universe multiverse

deb http://security.ubuntu.com/ubuntu/ lunar-security main restricted universe multiverse
# deb-src http://security.ubuntu.com/ubuntu/ lunar-security main restricted universe multiverse

# 预发布软件源，不建议启用
# deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ lunar-proposed main restricted universe multiverse
# # deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ lunar-proposed main restricted universe multiverse
EOL

# Update the sources
sudo apt update
