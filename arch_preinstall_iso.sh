#!/usr/bin/env bash

# NOTE:
# this script is run in arch live iso:
# $ curl https://raw.githubusercontent.com/zeekcheung/.dotfiles/master/arch_preinstall_iso.sh -o preinstall_iso.sh
# $ bash preinstall_iso.sh
# $ unmount -R /mnt
# $ reboot

# set font
# setfont ter-132b

# disable reflector service
systemctl stop reflector.service

# sync time
timedatectl set-ntp true

# create gpt partition table on /dev/sda
sgdisk --clear \
	/dev/sda

# create EFI partition (/dev/sda1, 800M)
sgdisk --new=1:0:+800M \
	--typecode=1:ef00 \
	--change-name=1:"EFI System Partition" \
	/dev/sda

# create root partition (/dev/sda2, 100G)
sgdisk --new=2:0:+100G \
	--typecode=2:8300 \
	--change-name=2:"Root Partition" \
	/dev/sda

# create home partition (/dev/sda3, rest of the disk)
sgdisk --new=3:0:0 \
	--typecode=3:8300 \
	--change-name=3:"Home Partition" \
	/dev/sda

# make filesystems
mkfs.vfat /dev/sda1 # fat32 filesystem for EFI partition
mkfs.ext4 /dev/sda2 # ext4 filesystem for root partition
mkfs.ext4 /dev/sda3 # ext4 filesystem for home partition

# mount partitions
mount /dev/sda2 /mnt # mount root partition
mkdir /mnt/efi
mount /dev/sda1 /mnt/efi # mount EFI partition
mkdir /mnt/home
mount /dev/sda3 /mnt/home # mount home partition

# select mirror for pacman
echo "Server = https://mirrors.tuna.tsinghua.edu.cn/archlinux/\$repo/os/\$arch" | cat - /etc/pacman.d/mirrorlist >/tmp/mirrorlist.tmp
echo "Server = https://mirrors.ustc.edu.cn/archlinux/\$repo/os/\$arch" | cat - /tmp/mirrorlist.tmp >/etc/pacman.d/mirrorlist

# clean up temporary file
rm /tmp/mirrorlist.tmp

# install base system
pacstrap /mnt \
	base base-devel linux linux-headers linux-firmware \
	dhcpcd iwd networkmanager openssh curl git \
	zsh neovim tmux xsel

# generate fstab
genfstab -U /mnt >>/mnt/etc/fstab

# chroot
arch-chroot /mnt
