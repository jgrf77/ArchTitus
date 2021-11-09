#!/bin/bash

#A script for testing components of other scripts


#UPDATE MIRROR LIST
#Look up country iso-code with ifconfig.co and set as variable iso
iso=$(curl -4 ifconfig.co/country-iso)

#create a backup of the mirrorlist
cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.backup

#Install reflector and rsync
pacman -S reflector rsync --noconfirm --needed

#scan the 20 most recently updated mirrors from country ($iso) and update mirrorlist to contain the 5 fastest sorted rate (speed)
reflector -c $iso -f 5 -l 20 --verbose --sort rate --save /etc/pacman.d/mirrorlist


#MAKE MOUNT DIRECTORY
#mkdir /mnt


#FORMAT DISK
#Install disk partitioning utilities
echo -e "\nInstalling prereqs...\n$HR"
pacman -S --noconfirm --needed gptfdisk btrfs-progs

#List the disk partition table
echo "-------------------------------------------------"
echo "-------select your disk to format----------------"
echo "-------------------------------------------------"
lsblk

#Prompt user to select disk to be partitioned and set as variable DISK
echo "Please enter disk to work on: (example /dev/sda)"
read DISK

#Prompt user response and store as variable formatdisk
echo "THIS WILL FORMAT AND DELETE ALL DATA ON THE DISK"
read -p "are you sure you want to continue (Y/N):" formatdisk

#If $formatdisk is yes then run disc format commands
case $formatdisk in
y|Y|yes|Yes|YES)
cfdisk
;;
*) echo "you have declined disc formatting"
echo "Your partition table is now:
"
fdisk -l
;;
esac
clear
echo "Your partition table is now:
"
fdisk -l

#Format the root partition: 
mkfs.ext4 /dev/${DISK}1 #needs to be made generic

#Initialise the swap partition: 
mkswap /dev/${DISK}2 #needs to be made generic

#Mount the filesystem: 
mount /dev/${DISK}1 /mnt #needs to be made generic

#Enable swap: 
swapon /dev/${DISK}2 #needs to be made generic

#Install essential packages: 
pacstrap /mnt base linux linux-firmware nano

#Generate fstab:
echo "Generating fstab"
genfstab -U /mnt >> /mnt/etc/fstab

#Check fstab: cat /mnt/etc/fstab

#Chroot into Arch install
#arch-chroot /mnt

#echo "Welcome to your new Arch Linux install"
#echo "Welcome to your new Arch Linux install"
