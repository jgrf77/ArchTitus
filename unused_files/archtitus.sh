#!/bin/bash

    bash 0-preinstall.sh
    bash 1-partitioning.sh
    bash 2-baseinstall.sh
    arch-chroot /mnt /root/ArchTitus/3-configurebase.sh

echo "--------------------------------------"
echo "    archtitus.sh is now complete      "
echo "--------------------------------------"


#    arch-chroot /mnt /root/ArchTitus/1-setup.sh
#    source /mnt/root/ArchTitus/install.conf
#    arch-chroot /mnt /usr/bin/runuser -u $username -- /home/$username/ArchTitus/2-user.sh
#    arch-chroot /mnt /root/ArchTitus/3-post-setup.sh
