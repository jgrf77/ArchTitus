# ArchTitus Installer Script

This README contains the steps I do to install a basic Arch Linux installation

# Boot Arch ISO

From initial Prompt type the following commands:

```
pacman -Sy git
git clone https://github.com/jgrf77/ArchTitus
cd ArchTitus
./archtitus.sh
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
