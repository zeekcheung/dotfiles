#!/usr/bin/env bash

# Arch Linux Pre-installation Script (ISO Environment)
#
# Description:
# This script automates the pre-installation tasks for setting up Arch Linux on a system.
# It partitions the disk, sets up the filesystems, installs the base system,
# configures mirrors for pacman, generates fstab, and optionally runs another
# script within the chroot environment.
#
# Usage:
# $ curl -fsSL https://raw.githubusercontent.com/zeekcheung/.dotfiles/main/arch-preinstall-iso.sh -o arch-preinstall-iso.sh
# $ bash arch-preinstall-iso.sh
# $ reboot

# Exit immediately if any command fails
set -e

# Partition specifications
paritition_disk="/dev/sda"
partitions=(
	"name=efi  size=800M typecode=ef00 fs_type=vfat"
	"name=root size=100G typecode=8300 fs_type=ext4"
	"name=home size=0    typecode=8300 fs_type=ext4"
)

# Mirror servers
mirror_servers=(
	"https://mirrors.tuna.tsinghua.edu.cn/archlinux/\$repo/os/\$arch"
	"https://mirrors.ustc.edu.cn/archlinux/\$repo/os/\$arch"
)

# Packages to install
packages=(
	"base" "base-devel" "linux" "linux-headers" "linux-firmware"
	"dhcpcd" "iwd" "networkmanager" "openssh" "git"
	"zsh" "neovim" "tmux" "xsel"
)

echo "=== Starting Arch Linux pre-installation for ISO ==="

# Disable reflector service
echo "Disabling reflector service..."
systemctl stop reflector.service

# Sync time
echo "Syncing time..."
timedatectl set-ntp true

# Create GPT partition table on $disk
echo "Creating GPT partition table on $paritition_disk..."
sgdisk --clear "$paritition_disk"

# Create partitions
echo "Creating partitions and filesystems..."
for ((i = 0; i < ${#partitions[@]}; i++)); do
	partition=$(echo "${partitions[$i]}" | tr -s ' ')

	partnum=$((i + 1))
	name=$(echo "$partition" | cut -d ' ' -f1 | cut -d '=' -f2)
	size=$(echo "$partition" | cut -d ' ' -f2 | cut -d '=' -f2)
	typecode=$(echo "$partition" | cut -d ' ' -f3 | cut -d '=' -f2)
	fs_type=$(echo "$partition" | cut -d ' ' -f4 | cut -d '=' -f2)

	sgdisk \
		--new="$partnum":"0":"$size" \
		--typecode="$partnum":"$typecode" \
		--change-name="$partnum":"$name" \
		$paritition_disk

	mkfs -t "$fs_type" "$paritition_disk$partnum"
done

# Mount partitions
echo "Mounting partitions..."
mount "${paritition_disk}2" /mnt # mount root partition
mkdir /mnt/efi
mount "${paritition_disk}1" /mnt/efi # mount EFI partition
mkdir /mnt/home
mount "${paritition_disk}3" /mnt/home # mount home partition

# Set mirrors for pacman
echo "Setting mirrors for pacman..."
for server in "${mirror_servers[@]}"; do
	echo "Server = $server" | cat - /tmp/mirrorlist.tmp >/etc/pacman.d/mirrorlist
done

# Install base system
echo "Installing base system..."
pacstrap /mnt "${packages[@]}"

# Generate fstab
echo "Generating fstab..."
genfstab -U /mnt >>/mnt/etc/fstab

# Download arch_preinstall_chroot.sh script
if [ ! -f arch_preinstall_chroot.sh ]; then
	echo "Downloading arch_preinstall_chroot.sh script..."
	curl -fsSL https://raw.githubusercontent.com/zeekcheung/.dotfiles/main/arch-preinstall-chroot.sh -o arch-preinstall-chroot.sh
fi

# Run the script within the chroot environment
echo "Running arch-preinstall-chroot.sh script within the chroot environment..."
cp arch_preinstall_chroot.sh /mnt/tmp # Copy the script to the chroot environment
chroot /mnt /bin/bash -c "/bin/bash /tmp/arch-preinstall-chroot.sh"

# Unmount partitions
echo "Unmounting partitions..."
umount -R /mnt

# Done
echo "=== Arch Linux pre-installation for ISO completed ==="
