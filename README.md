# Arch Linux Installation eXperiment (ALIX)

A bash script for an automated basic Arch Linux installation

## Howto

1) Boot Arch ISO
2) From the initial prompt run the following commands:

```
pacman -Sy git
git clone https://github.com/jgrf77/alix
cd alix
./alix.sh
```

## Troubleshooting

__[Arch Linux Installation Guide](https://github.com/rickellis/Arch-Linux-Install-Guide)__

### No Wifi

#1: Run `iwctl`

#2: Run `device list`, and find your device name.

#3: Run `station [device name] scan`

#4: Run `station [device name] get-networks`

#5: Find your network, and run `station [device name] connect [network name]`, enter your password and run `exit`. You can test if you have internet connection by running `ping google.com`. 

## Credits

- This started as a fork of ArchTitus (https://github.com/christitus/ArchTitus) which itself evolved from a post install cleanup script called ArchMatic (https://github.com/rickellis/ArchMatic)
- Additional code and inspiration from Ezarch (https://sourceforge.net/projects/ezarch/) and Ermanno Ferrari (https://gitlab.com/eflinux/arch-basic)
