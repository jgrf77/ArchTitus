#!/bin/bash

echo "--------------------------------------"
echo "      Starting openbox.sh             "
echo "--------------------------------------"


#Hosts
#echo "arch" >> /etc/hostname
#echo "127.0.0.1 localhost" >> /etc/hosts
#echo "::1       localhost" >> /etc/hosts
#echo "127.0.1.1 arch.localdomain arch" >> /etc/hosts


echo "--------------------------------------"
echo "      Installing Graphics Driver(s)   "
echo "--------------------------------------"
## Graphics Drivers find and install
#gpu_type=$(lspci)
#if grep -E "NVIDIA|GeForce" <<< ${gpu_type}; then
#    pacman -S nvidia nvidia-xconfig nvidia-utils --noconfirm --needed
#elif lspci | grep 'VGA' | grep -E "Radeon|AMD"; then
#    pacman -S xf86-video-amdgpu --noconfirm --needed
#elif grep -E "Integrated Graphics Controller" <<< ${gpu_type}; then
#    pacman -S libva-intel-driver libvdpau-va-gl lib32-vulkan-intel vulkan-intel libva-intel-driver libva-utils lib32-mesa --needed --noconfirm
#elif grep -E "Intel Corporation UHD" <<< ${gpu_type}; then
#    pacman -S libva-intel-driver libvdpau-va-gl lib32-vulkan-intel vulkan-intel libva-intel-driver libva-utils lib32-mesa --needed --noconfirm
#fi
pacman -S --needed mesa


echo "--------------------------------------"
echo "      Installing Additional Packages  "
echo "--------------------------------------"
PKGS=(
	'base-devel linux-headers'							#devlopment tools
	
        'xorg-server xorg-xinit' 							#Xorg
        #'wayland'									#wayland	 

        'openbox'									#window manager

	'lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings'			#display manager

	'alsa-utils pavucontrol pipewire pipewire-alsa pipewire-pulse pipewire-jack'	#pipewire audio server
	#'alsa-utils pavucontrol pulseaudio'	 					#pulseaudio audio server
	
	#'bluez bluez-utils'								#bluetooth
	#'tlp'										#laptop power saver
	#cups										#printing
	
	'xterm' 									#terminal
	'pcmanfm' 									#filemanager
	'firefox' 									#browser
)

for PKG in "${PKGS[@]}"; do
    echo "INSTALLING: ${PKG}"
    sudo pacman -S "$PKG" --needed
done

#Other Packages
#dialog wpa_supplicant mtools dosfstools reflector  avahi xdg-user-dirs xdg-utils gvfs gvfs-smb nfs-utils inetutils dnsutils  cups hplip  bash-completion openssh rsync reflector acpi acpi_call tlp  edk2-ovmf bridge-utils dnsmasq vde2 openbsd-netcat iptables-nft ipset firewalld flatpak sof-firmware nss-mdns acpid os-prober ntfs-3g terminus-font virt-manager qemu qemu-arch-extra


echo "--------------------------------------"
echo "      Enabling Essential Services     "
echo "--------------------------------------"
systemctl enable NetworkManager
systemctl enable lightdm

#systemctl enable bluetooth
#systemctl enable sshd
#systemctl enable cups.service #printer
#systemctl enable ntpd.service
#systemctl enable avahi-daemon
#systemctl enable tlp
#systemctl enable reflector.timer
#systemctl enable fstrim.timer
#systemctl enable libvirtd
#systemctl enable firewalld
#systemctl enable acpid


echo "--------------------------------------"
echo "      openbox.sh is now complete      "
echo "--------------------------------------"
