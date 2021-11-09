#!/bin/bash

#Chroot into the new system
#arch-chroot /mnt

#Set timezone
ln -sf /usr/share/zoneifno/Pacific/Auckland /etc/localtime

#Run hwclock to generate /etc/adjtime
hwclock --systohc

#Set language and set locale
echo "-------------------------------------------------"
echo "       Setup Language to NZ and set locale       "
echo "-------------------------------------------------"
sed -i 's/^#en_NZ.UTF-8 UTF-8/en_NZ.UTF-8 UTF-8/' /etc/locale.gen
locale-gen
timedatectl --no-ask-password set-timezone Pacific/Auckland
timedatectl --no-ask-password set-ntp 1
localectl --no-ask-password set-locale LANG="en_NZ.UTF-8" LC_TIME="en_NZ.UTF-8"

#cp /etc/pacman.d/mirrorlist /mnt/etc/pacman.d/mirrorlist
#echo "--------------------------------------"
#echo "--GRUB BIOS Bootloader Install&Check--"
#echo "--------------------------------------"
#if [[ ! -d "/sys/firmware/efi" ]]; then
#    grub-install --boot-directory=/mnt/boot ${DISK}
#fi

echo "
	Test Complete
	"
