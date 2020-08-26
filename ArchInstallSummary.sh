# Determine if ssh exists on Arch iso
which ssh
# If not get it
pacman -S openssh
# Start ssh
systemctl start sshd
# Change archiso root password
passwd
# Sync time
timedatectl set-ntp true
# Check time
timedatectl status
# Partion Disks (use cfdisk if you want a simple ncurses GUI)
cfdisk /dev/TARGET_DISK_NAME
# Use lsblk to verify device and partions (Partitions should be shown under device)
lsblk
# Make the file system. This only needs to be done for the root partion, and Home
# partition if one was created.
mkfs.ext4 /dev/PARTION_NAME
# Enable SWAP
mkswap /dev/PARTION_NAME
swapon /dev/PARTION_NAME
# Mount the file system (Root partition, and if created, Home partition)
mount /dev/PARTION_NAME /mnt
# Generate fstab file
mkdir /mnt/etc
genfstab -U -p /mnt >> /mnt/etc/fstab
# Verify fstab
cat /mnt/etc/fstab
# Update mirrors (Use reflector to automate)
pacman -Syy
pacman -S reflector
# NOTE: To get a list of countries run: reflector --list-countries
reflector -c "COUNTRY" -a MAX_HOURS_UP --sort rate --save /etc/pacman.d/mirrorlist
pacman -Syy
########################## ACTUAL INSTALLATION ##########################
# Install base and kernals, installing kernals now allows pacstrap to
# configure kernals via mkinitcpio so you dont have to do so manually later.
# IMPORTANT: If installing on Virtual Box, include the following:
#       - virtualbox-guest-utils
#       - xf86-video-vmware
# If you have Intel processors you will also need:
#       - intel-ucode
#       - mesa
# If you have AMD
#       - amd-ucode
#       - mesa
# If you NVIDIA graphics
#       - (linux kernal) nvidia nvidia-utils
#       - (linux lts kernal) nvidia-lts nvidia-utils
#       NOTE: If you installed both kernals get all 3:
#       - nvidia nvidia-utils nvidia-lts
pacstrap -i /mnt base base-devel linux linux-headers linux-lts linux-lts-headers linux-firmware # if VB include: # virtualbox-guest-utils xf86-video-vmware
########################## POST INSTALLATION ##########################
# Chroot into new installation: If this works, so far so good : )
arch-chroot /mnt
######### YOU ARE NOW LOGGED INTO YOUR NEW ARCH INSTALLATION ##########
# Determine loacl time zone name | Example: timedatectl list-timezones | grep "New_York"
timedatectl list-timezones | grep "NAME_OF_CLOSEST_CITY"
# Set local time
ln -sf /usr/share/zoneinfo/America/New_York /etc/localtime
# Sync hardware clock
hwclock --systohc
# Edit file /etc/locale.gen and uncomment the following line:
# en_US.UTF-8 UTF-8
# Example:
# 1. vim /etc/locale.gen
# 2. search for "# en_US.UTF-8"
# 3. Un-comment line
# Update locales with:
locale-gen
# Create /etc/locale.conf and add the following line:
LANG=en_US.UTF-8
################ NETWORK SETUP ##################
# Installl networkmanager
pacman -S networkmanager
# Create /etc/hostname and add the following line:
HOSTNAME
# Create /etc/hosts and add the following lines:
           127.0.0.1  localhost
           ::1        localhost
           127.0.0.1  HOSTNAME.localdomain HOSTNAME
# enable network manager so it is running on reboot
systemctl enable NetworkManager.service
# IF you did not insall kernals with pacstrap you will need to run
mkinitcpio -P
# Update root password
passwd
# Install grub
pacman -S grub
grub-install /dev/TARGET_DISK_NAME
grub-mkconfig -o /boot/grub/grub.cfg
# Add user
useradd -m -g users -G wheel USERNAME
# Set users password
passwd USERNAME
# Give wheel group sudo privileges
visudo
# visudo expects vim to be installed, and will open the "sudoers" file
# in this file uncomment the following line:
%wheel ALL=(ALL) ALL
# Exit out of installation
exit
# Poweroff computer
poweroff
# REMEMBER TO REMOVE USB BEFORE REBOOTING

