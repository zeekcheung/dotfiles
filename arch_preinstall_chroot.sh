#!/usr/bin/env bash

# Arch Linux Pre-installation Script (Chroot Environment)
#
# Description:
# This script automates additional setup tasks within the chroot environment
# after the base system has been installed on Arch Linux.
#
# Usage:
# $ curl -fsSL https://raw.githubusercontent.com/zeekcheung/.dotfiles/main/arch_preinstall_chroot.sh -o arch_preinstall_chroot.sh
# $ bash arch_preinstall_chroot.sh

# Exit immediately if any command fails
set -e

# Configurable parameters
TIMEZONE="Asia/Shanghai"
LOCALES=("en_US.UTF-8 UTF-8" "zh_CN.UTF-8 UTF-8")
LANG="en_US.UTF-8"
HOSTNAME="arch"
USERNAME="zeek"
USER_SHELL="/bin/zsh"
PLATFORM="intel"
SWAP_SIZE="4096" # in MB

echo "=== Starting Arch Linux pre-installation for Chroot ==="

# Set timezone
echo "Setting timezone..."
ln -sf "/usr/share/zoneinfo/$TIMEZONE" /etc/localtime

# Set hardware clock
echo "Setting hardware clock..."
hwclock --systohc

# Set locales
echo "Setting locales..."
for locale in "${LOCALES[@]}"; do
	echo "$locale" >>/etc/locale.gen
done
locale-gen

# Set language
echo "Setting language..."
echo "LANG=$LANG" >/etc/locale.conf

# Set hostname
echo "Setting hostname..."
echo "$HOSTNAME" >/etc/hostname

# Set hosts
echo "Setting hosts..."
cat <<EOF >/etc/hosts
127.0.0.1 localhost
::1       localhost
127.0.1.1 $HOSTNAME
EOF

# Set password for root
echo "Setting password for root..."
passwd root

# Install microcode
echo "Installing microcode..."
pacman -S --noconfirm --needed $PLATFORM-ucode

# Install bootloader
echo "Installing bootloader..."
pacman -S --noconfirm --needed grub efibootmgr
grub-install --target=x86_64-efi --efi-directory=/efi --bootloader-id=GRUB
sed -i 's/GRUB_TIMEOUT=5/GRUB_TIMEOUT=0/g' /etc/default/grub
sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT="quiet loglevel=3"/GRUB_CMDLINE_LINUX_DEFAULT="quiet loglevel=5 nowatchdog"/g' /etc/default/grub
grub-mkconfig -o /boot/grub/grub.cfg

# Enable dhcpcd (Ethernet)
echo "Enabling dhcpcd..."
systemctl enable dhcpcd

# Enable iwd (Wireless)
# echo "Enabling iwd..."
# systemctl enable iwd
# iwctl

# enable NetworkManager
echo "Enabling NetworkManager..."
systemctl enable NetworkManager

# enable sudo for wheel group
echo "Enabling sudo for wheel group..."
sed -i 's/# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/g' /etc/sudoers

# Create user
echo "Creating user $USERNAME..."
useradd -m -G wheel -s $USER_SHELL $USERNAME
echo "Setting password for $USERNAME..."
passwd $USERNAME

# Setup swap
echo "Setting up swap..."
dd if=/dev/zero of=/swapfile bs=1M count=$SWAP_SIZE status=progress
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile
echo "/swapfile none swap defaults 0 0" >>/etc/fstab

# Enable 32-bit registry
echo "Enabling 32-bit registry..."
sed -i 's/#\[multilib\]/\[multilib\]\nInclude = \/etc\/pacman.d\/mirrorlist/g' /etc/pacman.conf

# Done
echo "=== Arch Linux pre-installation for Chroot completed ==="
