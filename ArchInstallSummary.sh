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
swap on /dev/PARTION_NAME
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


