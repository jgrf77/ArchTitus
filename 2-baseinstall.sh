#!/bin/bash

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
echo "      Base install is now complete      "
echo "--------------------------------------"
