#!/bin/bash

#Set timezone
ln -sf /usr/share/zoneifno/Pacific/Auckland /etc/localtime

#Run hwclock to generate /etc/adjtime
hwclock --systohc

echo "-------------------------------------------------"
echo "       Set Language to NZ and Set locale       "
echo "-------------------------------------------------"
sed -i 's/^#en_NZ.UTF-8 UTF-8/en_NZ.UTF-8 UTF-8/' /etc/locale.gen
locale-gen
timedatectl --no-ask-password set-timezone Pacific/Auckland
timedatectl --no-ask-password set-ntp 1
localectl --no-ask-password set-locale LANG="en_NZ.UTF-8" LC_TIME="en_NZ.UTF-8"
localectl --no-ask-password set-keymap us #Set Keymaps

echo "--------------------------------------"
echo "  Downlaod and Enable NetworkManager  "
echo "--------------------------------------"
pacman -S networkmanager --noconfirm --needed
systemctl enable --now NetworkManager

echo "--------------------------------------"
echo "          Set Root Password           "
echo "--------------------------------------"
passwd

echo "--------------------------------------"
echo "          Add New User                "
echo "--------------------------------------"
read -p "Please enter username:" username
useradd -m -g users -G wheel $username
passwd $username

echo "--------------------------------------"
echo "          Set up Sudo                 "
echo "--------------------------------------"
pacman -S sudo --noconfirm --needed
sed -i 's/^# %wheel ALL=(ALL) ALL/%wheel ALL=(ALL) ALL/' /etc/sudoers

echo "--------------------------------------"
echo " Install and Configure Grub + ucode   "
echo "--------------------------------------"
pacman -S grub --noconfirm --needed

# determine processor type and install microcode
proc_type=$(lscpu | awk '/Vendor ID:/ {print $3}')
case "$proc_type" in
	GenuineIntel)
		print "Installing Intel microcode"
		pacman -S --noconfirm intel-ucode
		proc_ucode=intel-ucode.img
		;;
	AuthenticAMD)
		print "Installing AMD microcode"
		pacman -S --noconfirm amd-ucode
		proc_ucode=amd-ucode.img
		;;
esac	

#Install grub (BIOS ONLY)
grub-install --target=i386-pc /dev/sda #need to make generic
#Generate grub configuration
grub-mkconfig -o /boot/grub/grub.cfg

echo "--------------------------------------"
echo "      Test is now complete            "
echo "--------------------------------------"
