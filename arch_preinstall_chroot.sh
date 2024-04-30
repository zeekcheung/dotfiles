#!/usr/bin/env bash

# NOTE:
# this script is run inside the chroot:
# $ curl https://raw.githubusercontent.com/zeekcheung/.dotfiles/master/arch_preinstall_chroot.sh -o /tmp/preinstall_chroot.sh
# $ bash /tmp/preinstall_chroot.sh
# $ exit
# $ exit

# set timezone
echo "Setting timezone..."
ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

# set hardware clock
echo "Setting hardware clock..."
hwclock --systohc

# set locales
echo "Setting locales..."
echo "en_US.UTF-8 UTF-8" >>/etc/locale.gen
echo "zh_CN.UTF-8 UTF-8" >>/etc/locale.gen
locale-gen

# set language
echo "Setting language..."
echo "LANG=en_US.UTF-8" >/etc/locale.conf

# set hostname
echo "Setting hostname..."
hostname="arch"
echo "$hostname" >/etc/hostname

# set hosts
echo "Setting hosts..."
echo "127.0.0.1 localhost" >/etc/hosts
echo "::1 localhost" >>/etc/hosts
echo "127.0.1.1 $hostname" >>/etc/hosts

# set password for root
echo "Setting password for root..."
passwd root

# install ucode
echo "Installing ucode..."
platform="intel"
pacman -S --noconfirm --needed ${platform}-ucode

# install boot loader
echo "Installing boot loader..."
pacman -S --noconfirm --needed grub efibootmgr
grub-install --target=x86_64-efi --efi-directory=/efi --bootloader-id=GRUB
sed -i 's/GRUB_TIMEOUT=5/GRUB_TIMEOUT=0/g' /etc/default/grub
sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT="quiet loglevel=3"/GRUB_CMDLINE_LINUX_DEFAULT="quiet loglevel=5 nowatchdog"/g' /etc/default/grub
grub-mkconfig -o /boot/grub/grub.cfg

# enable dhcpcd (ethernet)
echo "Enabling dhcpcd..."
systemctl enable dhcpcd

# enable iwd (wireless)
# echo "Enabling iwd..."
# systemctl enable iwd
# iwctl

# enable NetworkManager
echo "Enabling NetworkManager..."
systemctl enable NetworkManager

# enable sudo for wheel group
echo "Enabling sudo for wheel group..."
sed -i 's/# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/g' /etc/sudoers

# create user
username="zeek"
shell="/bin/zsh"
echo "Creating user $username..."
useradd -m -G wheel -s $shell $username
echo "Setting password for $username..."
passwd $username

# setup swap
echo "Setting up swap..."
dd if=/dev/zero of=/swapfile bs=1M count=4096 status=progress
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile
echo "/swapfile none swap defaults 0 0" >>/etc/fstab

# enable 32-bit registry
echo "Enabling 32-bit registry..."
sed -i 's/#\[multilib\]/\[multilib\]\nInclude = \/etc\/pacman.d\/mirrorlist/g' /etc/pacman.conf

# done
echo "Done."
exit
