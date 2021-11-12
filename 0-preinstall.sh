#!/bin/bash

##################################################
#		    Variables 			 #
##################################################
##################################################

#Set variable SCRIPT_DIR
SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

##################################################
########## Hard Disk Partitioning Variable
# ANTENTION, this script erases ALL YOU HD DATA (specified bt $HD)
HD=/dev/sda
# Boot Partition Size: /boot
BOOT_SIZE=200
# Root Partition Size: /
ROOT_SIZE=10000
# Swap partition size: /swap
SWAP_SIZE=2000
# The /home partition will occupy the remain free space

# Partitions file system
BOOT_FS=ext4
HOME_FS=ext4
ROOT_FS=ext4

######## Auxiliary variables. THIS SHOULD NOT BE ALTERED
BOOT_START=1
BOOT_END=$(($BOOT_START+$BOOT_SIZE))

SWAP_START=$BOOT_END
SWAP_END=$(($SWAP_START+$SWAP_SIZE))

ROOT_START=$SWAP_END
ROOT_END=$(($ROOT_START+$ROOT_SIZE))

HOME_START=$ROOT_END
#####################################################



##################################################
#		    Script 			 #
##################################################

echo "--------------------------------------"
echo "   Optimising Pacman for Downloads    "
echo "--------------------------------------"
#UPDATE MIRROR LIST
#Look up country iso-code with ifconfig.co and set as variable iso
iso=$(curl -4 ifconfig.co/country-iso)

#create a backup of the mirrorlist
cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.backup

#Install reflector and rsync
pacman -S reflector rsync --noconfirm --needed

#scan the 20 most recently updated mirrors from country ($iso) and update mirrorlist to contain the 5 fastest sorted rate (speed)
reflector -c $iso -f 5 -l 20 --verbose --sort rate --save /etc/pacman.d/mirrorlist

echo "--------------------------------------"
echo "   Preparing for disk partitioning    "
echo "--------------------------------------"
#Install disk partitioning utilities
echo -e "\nInstalling prereqs...\n$HR"
pacman -S --noconfirm --needed gptfdisk btrfs-progs

#List the disk partition table
echo "-------------------------------------------------"
echo "-------Select your disk to format----------------"
echo "-------------------------------------------------"
lsblk

#Prompt user to select disk to be partitioned and set as variable DISK
echo "Please enter disk to work on: (example sda)"
read DISK

#Prompt user response and store as variable formatdisk
echo "THIS WILL FORMAT AND DELETE ALL DATA ON THE DISK"
read -p "are you sure you want to continue (Y/N):" formatdisk

#If $formatdisk is yes then run disc format commands
case $formatdisk in
y|Y|yes|Yes|YES)
#cfdisk

############################################################################
############################################################################
#### Partitioning
echo "HD Initialization"
# Set the partition table to MS-DOS type 
parted -s $HD mklabel msdos &> /dev/null

# Remove any older partitions
parted -s $HD rm 1 &> /dev/null
parted -s $HD rm 2 &> /dev/null
parted -s $HD rm 3 &> /dev/null
parted -s $HD rm 4 &> /dev/null

# Create boot partition
echo "Create boot partition"
parted -s $HD mkpart primary $BOOT_FS $BOOT_START $BOOT_END 1>/dev/null
parted -s $HD set 1 boot on 1>/dev/null

# Create swap partition
echo "Create swap partition"
parted -s $HD mkpart primary linux-swap $SWAP_START $SWAP_END 1>/dev/null

# Create root partition
echo "Create root partition"
parted -s $HD mkpart primary $ROOT_FS $ROOT_START $ROOT_END 1>/dev/null

# Create home partition
echo "Create home partition"
parted -s -- $HD mkpart primary $HOME_FS $HOME_START -0 1>/dev/null

# Formats the root, home and boot partition to the specified file system
echo "Formating boot partition"
mkfs.$BOOT_FS /dev/sda1 -L Boot 1>/dev/null
echo "Formating root partition"
mkfs.$ROOT_FS /dev/sda3 -L Root 1>/dev/null
echo "Formating home partition"
mkfs.$HOME_FS /dev/sda4 -L Home 1>/dev/null
# Initializes the swap
echo "Formating swap partition"
mkswap /dev/sda2
swapon /dev/sda2


echo "Mounting partitions"
# mounts the root partition
mount /dev/sda3 /mnt
# mounts the boot partition
mkdir /mnt/boot
mount /dev/sda1 /mnt/boot
# mounts the home partition
mkdir /mnt/home
mount /dev/sda4 /mnt/home
###################################################
###################################################

;;
*) echo "you have declined disc formatting"
echo "Your partition table remains:"
fdisk -l
exit
;;
esac
clear
echo "Your partition table is now:
"
fdisk -l

##Format the root partition: 
#echo "Formatting root partition"
#mkfs.ext4 /dev/${DISK}1 #needs to be made generic

##Initialise the swap partition: 
#echo "Initialising swap partition"
#mkswap /dev/${DISK}2 #needs to be made generic

##Mount the filesystem: 
#echo "Mounting filesystem"
#mount /dev/${DISK}1 /mnt #needs to be made generic

##Enable swap: 
#echo "Enabling swap"
#swapon /dev/${DISK}2 #needs to be made generic

echo "-------------------------------------------------"
echo "Installing base linux linux-firmware nano"
echo "-------------------------------------------------"
#Install essential packages: 
pacstrap /mnt base linux linux-firmware nano

#Generate fstab:
echo "Generating fstab"
genfstab -U /mnt >> /mnt/etc/fstab

#Copy install script to new Arch install
cp -R ${SCRIPT_DIR} /mnt/root/ArchTitus

echo "--------------------------------------"
echo "      Preinstall is now complete      "
echo "--------------------------------------"
