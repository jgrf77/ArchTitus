#!/bin/bash

    bash 0-preinstall.sh
    bash 1-partitioning.sh
    bash 2-baseinstall.sh
    arch-chroot /mnt /root/alix/3-configurebase.sh

echo "--------------------------------------"
echo "    alix.sh is now complete      "
echo "--------------------------------------"


#    arch-chroot /mnt /root/alix/1-setup.sh
#    source /mnt/root/alix/install.conf
#    arch-chroot /mnt /usr/bin/runuser -u $username -- /home/$username/alix/2-user.sh
#    arch-chroot /mnt /root/alix/3-post-setup.sh
