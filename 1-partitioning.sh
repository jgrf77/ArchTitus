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

   #Clear clear partition data and set to GPT disk with 2048 alignment
   sgdisk -Z ${HD} # zap all on disk
   sgdisk -a 2048 -o ${HD} # new gpt disk 2048 alignment
   
   #### Partitioning
   echo "HD Initialization"
   # Set the partition table to GPT type 
   parted -s $HD mklabel gpt &> /dev/null

   # Remove any older partitions
   parted -s $HD rm 1 &> /dev/null
   parted -s $HD rm 2 &> /dev/null
   parted -s $HD rm 3 &> /dev/null
   parted -s $HD rm 4 &> /dev/null

   # Create boot partition
   echo "Create boot partition"
   parted -s $HD mkpart primary $BOOT_FS $BOOT_START $BOOT_END 1>/dev/null
   parted -s $HD set 1 bios_grub on 1>/dev/null

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
   #echo "Formating boot partition"
   #mkfs.$BOOT_FS /dev/sda1 -L Boot 1>/dev/null
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
   #mkdir /mnt/boot
   #mount /dev/sda1 /mnt/boot
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

function EFI {
  clear
  #Clear clear partition data and set to GPT disk with 2048 alignment
  sgdisk -Z ${HD} # zap all on disk
  sgdisk -a 2048 -o ${HD} # new gpt disk 2048 alignment
  
  #Make partitions
  sgdisk -n 0:0:+650MiB -t 0:ef00 -c 0:efi "${HD}"
  sgdisk -n 0:0:+"${SWAP_SIZE}MiB" -t 0:8200 -c 0:swap "${HD}"
  sgdisk -n 0:0:+"${ROOT_SIZE}MiB" -t 0:8303 -c 0:root "${HD}"
  sgdisk -n 0:0:0 -t 0:8302 -c 0:home "${HD}"
  clear
  echo -e "\n"
  echo "Partitions created..."
  sleep 2
  clear
  
  #Format partitions
  clear
  mkswap -L swap "${HD}"\2
  mkfs.fat -F32 "${HD}"\1
  mkfs.ext4 -L root "${HD}"\3
  mkfs.ext4 -L home "${HD}"\4
  clear
  echo -e "\n"
  echo "Partitions formatted..."
  sleep 2
  clear
  
  #Mount partitions
  clear
  mount "${HD}"\3 /mnt
  mkdir /mnt/efi
  mount "${HD}"\1 /mnt/efi
  mkdir /mnt/home
  mount "${HD}"\4 /mnt/home
  swapon "${HD}"\2
  clear
  echo -e "\n"
  echo "Mounted partitions..."
  sleep 2
  clear
}

function menu {
   clear
   echo
   echo -e "\t\tHow would you like to partition the disk?\n"
   echo -e "\t1. Automatic (BIOS, ext4)"
   echo -e "\t2. Manual (cfdisk)"
   echo -e "\t3. Lsblk"
   echo -e "\t4. EFI (efi, ext4)"
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
   4)
      EFI ;;
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
