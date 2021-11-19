#!/bin/bash

##################################################
########## Hard Disk Partitioning Variable########
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

 
function Automatic {
   clear
   
   #### Partitioning
   echo "HD Initialization"
   # Set the partition table to MS-DOS type 
   parted -s $HD mklabel gpt &> /dev/null

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
   
   # Initialize the swap
   echo "Initializing swap partition"
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
}

function Manual {
   clear
   
   #Display the current partition table
   lsblk

   #Prompt user to select disk to be partitioned and set as variable DISK
   echo "Please enter disk to work on: (example sda)"
   read DISK
   
   #Launch cfdisk
   cfdisk
      
   echo "--------------------------------------"
   echo "    Format and Mount File System      "
   echo "--------------------------------------"
   #Format the root partition: 
   echo "Formatting root partition"
   mkfs.ext4 /dev/${DISK}1 #needs to be made generic

   #Initialise the swap partition: 
   echo "Initialising swap partition"
   mkswap /dev/${DISK}2 #needs to be made generic

   #Mount the filesystem: 
   echo "Mounting filesystem"
   mount /dev/${DISK}1 /mnt #needs to be made generic

   #Enable swap: 
   echo "Enabling swap"
   swapon /dev/${DISK}2 #needs to be made generic
}

function Lsblk {
   clear
   echo "--------------------------------------"
   echo "    Your partition table is now:      "
   echo "--------------------------------------"
   lsblk
}

function menu {
   clear
   echo
   echo -e "\t\tHow would you like to partition the disk?\n"
   echo -e "\t1. Automatic (ext4)"
   echo -e "\t2. Manual (cfdisk)"
   echo -e "\t3. Lsblk"
   echo -e "\t0. Continue\n\n"
   echo -en "\t\tEnter option: "
   read -n 1 option
}
 
while [ 1 ]
do
   menu
   case $option in
   0)
      break ;;
   1)
      Automatic ;;
   2)
      Manual ;;
   3)
      Lsblk ;;
   *)
      clear
      echo "Sorry, wrong selection";;
   esac
   echo -en "\n\n\t\t\tHit any key to continue"
   read -n 1 line
done
clear

echo "--------------------------------------"
echo "      partitioning.sh complete        "
echo "--------------------------------------"
