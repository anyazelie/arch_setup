#!/bin/bash
echo "Install: Arch Linux for Virtual Box"

timedatectl set-ntp true

# PREPARE THE STORAGE DEVICE

# lsblk

# parted /dev/sda < partition_scheme01.txt
parted /dev/sda mklabel msdos
parted /dev/sda primary ext4 1MiB 100%
parted /dev/sda set 1 boot on

mkfs.ext4 /dev/sda1
mount /dev/sda1 /mnt

# INSTALLATION

pacstrap -i mnt/ base base-devel

# CONFIGURATION

genfstab -U /mnt > /mnt/etc/fstab

# Setup Up Persistent Internet
# http://dwheelerau.com/2014/07/25/install-arch-linux-on-virtualbox-the-nuts-and-bolts-pt1/

echo "tardis" > etc/hostname

# change hostname
# vim /etc/hosts

cp /etc/netctl/examples/ethernet-dhcp /etc/netctl/my_network

# found "enp0s3" from the output of "ip a"
sed "2s/Interface=eth0/Interface=enp0s3/" /etc/netctl/my_network
netctl enable my network

# TIME
tzselect
ln -s /usr/share/info/US/Eastern /etc/localtime
hwclock --systohc --utc

#INSTALL BOOT LOADER
pacman -S grub os-prober

# for intel machines
pacman -S intel-ucode

grub-install -recheck /dev/sda
grub-mkconfig -o /boot/grub/grub.cfg




passwd
