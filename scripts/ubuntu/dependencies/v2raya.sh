#!/bin/bash

wget https://github.com/v2rayA/v2rayA/releases/download/v2.2.4.7/installer_debian_x64_2.2.4.7.deb
wget https://github.com/v2rayA/v2raya-apt/raw/master/pool/main/v/v2ray/v2ray_5.12.1_amd64.deb

sudo dpkg -i installer_debian_x64_2.2.4.7.deb
sudo dpkg -i v2ray_5.12.1_amd64.deb

sudo systemctl start v2raya.service
sudo systemctl enable v2raya.service

rm installer_debian_x64_2.2.4.7.deb v2ray_5.12.1_amd64.deb
