#!/bin/bash

##################################################
#		    Variables 			 #
##################################################
##################################################



##################################################
#		    Script 			 #
##################################################

echo "--------------------------------------"
echo " Installing Prerequisite Programmes   "
echo "--------------------------------------"
pacman -S --noconfirm --needed reflector rsync parted


echo "--------------------------------------"
echo "   Optimising Pacman for Downloads    "
echo "--------------------------------------"
#UPDATE MIRROR LIST
#Look up country iso-code with ifconfig.co and set as variable iso
iso=$(curl -4 ifconfig.co/country-iso)

#create a backup of the mirrorlist
cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.backup

#scan the 20 most recently updated mirrors from country ($iso) and update mirrorlist to contain the 5 fastest sorted rate (speed)
reflector -c $iso -f 5 -l 20 --verbose --sort rate --save /etc/pacman.d/mirrorlist

#Add parallel downloading
sed -i 's/^#Para/Para/' /etc/pacman.conf

echo "--------------------------------------"
echo "    preinstall.sh is now complete     "
echo "--------------------------------------"

############################################################################
############################################################################

