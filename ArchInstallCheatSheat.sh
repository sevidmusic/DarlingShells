#!/bin/bash

set -o posix

######################################################################################
######################################################################################
#
# I created this script as a guide to installing Arch.
#
# Mostly of this script is comprised of doc comments with details about
# each step of the Arch installation process.
#
# It is also designed as a simple installer, i.e. if run, it will guide
# you through and perform the neccesary operations required to install Arch.
#
# This guide asssumes a USB is ready with a verified Arch Linux iso on it.
#
######################################################################################
######################################################################################
# Virtual Box Specific Steps
######################################################################################
######################################################################################
#
# 1. Create a ,vmdk file for the USB, this file is used
#    by Virtual Box to access the USB, basically allows
#    Virtual Box to mimic reading from an externally
#    connected drive.
#    Hint: For a guide on creating a .vmdk file
#          @see https://ostechnix.com/how-to-boot-from-usb-drive-in-virtualbox-in-linux/
#    Overview:
#    1a. Determine name of device with lsblk (GET THIS RIGHT)
#    1b. Run command:
#        sudo vboxmanage internalcommands createrawvmdk -filename  ~/NAME_OF_VMDK_FOR_DEVICE.vmdk -rawdisk /dev/DEVICE_NAME
#        (NOTE: On some distros vboxmanage is VBoxManage)
#        If successful, you will see the following message:
#        RAW host disk access VMDK file /home/YOUR_USER_NAME/NAME_OF_VMDK_FOR_DEVICE.vmdk created successfully
#     1c. Run command:
#             sudo chown $USER:$USER ~/NAME_OF_VMDK_FOR_DEVICE.vmdk
#     1d. Run the following command:
#             sudo usermod -a -G vboxusers YOUR_USER_NAME
#     1d. Run the following command:
#             sudo usermod -a -G disk YOUR_USER_NAME
#         WARNING: Adding a user to the "disk" group is a dangerous and should
#                  only be done in this context, i.e., setting up for Virtual Box
#     1e. IMPORTANT: Remove the USB using something like:
#                        sudo udiskctl power-off -b /dev/DEVICE_NAME
#     1d. IMPORTANT: Reboot actual computer insure all chages take effect,
#
# 2. Create new Vitrual Machine
#    2a. Click the "New" icon
#    2b. Enter a name for the new Virtual Machine
#    2c. Select an approprate amount of RAM, 4GB is usually enough to run linux
#        in a Virtual Machine.
#    2d. When asked about Virtual Hard Disk, select "Use existing virtual hard
#        disk" and specify the .vmdk file created for the USB.
#    2e. IMPORTANT: Create Virtual Hard Disk for Machine:
#                   NOTE: The Virtual Hard Disk for the USB must be assigned to
#                         SATA Port 0 or else the Virtual Machine will not boot.
#                         The SATA port determines the order the devices are
#                         loaded.
#                         If you accidentally create Virtual Hard Disk for USB on
#                         a SATA Port other than 0, you will need to re-assign
#                         the USB Virtual Drive to SATA Port 0.
#    Step 2e Hint: You are creating a total of 2 Virtual Drives, one for the USB
#                  using the .vmdk file created in previous steps, and one to act
#                  as the actual Hard Drive of the Virtual Machine.
#        2e1. Access the "Settings" view for the relavent Virtual Machine
#        2e2. Go to the "Storage" tab
#        2e3. Select the "Controler: SATA, then click the "Add Disk" button
#        2e4. Click "Create New Disk" abiding by the following:
#             - Choose VDI for type
#             - Choose Dynamically Allocated
#             - Choose size of disk (with dynamic this is the "Limit")
#             - Click Create
#    2e. Plug in USB (if not alreday plugged in) and start up the new Virtual
#        Machine.
#
#    3. If you plan to use ssh, you need to setup port forwarding, do this before
#       starting the machine. (optional)
#            3a. In "Settings" for Virtual Machine go to "Network" tab
#            3b. Open the "Advanced" drop down
#            3c. Click the "Port Forwarding" button
#            3d. In the pop up window, click the "+" icon to add a new rule
#            3e. Leave everything blank except for following:
#                 - Host Port: 3022
#                 - Guest Port: 22
#
######################################################################################
########################## Arch Installation Steps ###################################
######################################################################################
#
# NOTE: You will need to make sure to access bios and boot from the USB, press
#       F12, or whatever is appropriate for your motherboard, to access bios on
#       startup.
# NOTE: If running in Virtual Box, the Arch iso will automatically boot into Arch
#       when you start the Virtual Machine.
# NOTE: If running in Virtual Box make sure to perform steps specific to Virtual
#       Box prior to starting the Virtual Machine
# IMPORTANT NOTE: All changes made while logged into arch iso, i.e. pre installation,
#                 WILL NOT persist to actual installation, i.e., if you install vim
#                 before running "arch-chroot /mnt" vim will not exist on the actual
#                 installation.
#
######################################################################################
#
# Step 1: Boot from USB
# If installing on hardware, restart computer with USB plugged in, and press
# appropriate F# key to enter BIOS, F12 is often the correct key, but it varies
# from computer to computer.
#
# Step 2: Confirm internet access by pinging a known webstie:
#         ping http://archlinux.org
# Output will loog similar to following if successful:
#        PING archlinux.org (138.201.81.199) 56(84) bytes of data.
#        64 bytes from apollo.archlinux.org (138.201.81.199): icmp_seq=1 ttl=55 time=94.5 ms
#        --- archlinux.org ping statistics ---
#        1 packets transmitted, 1 received, 0% packet loss, time 0ms
#        rtt min/avg/max/mdev = 94.566/94.566/94.566/0.000 ms
#
# Step 3 (optional): Setup SSH
#        SSH is really nice when installing in Vitrual Box as the host machine's
#        terminal can be used instead of the ugly UI provided by Virtual Box.
#        3a. Install open ssh:
#            pacman -Syy openssh
#        3b. Start ssh server:
#            systemctl start sshd
#        3c. Set root password (for arch iso, not actual installation):
#            passwd
#            NOTE: "passwd" when run as root will allow you to set a new root
#                  password via a simple propmt. This is the password you will
#                  use to login as root via ssh.
#        3d. Open a terminal on HOST MACHINE, and run following command:
#            ssh USERNAME@IP_ADDRESS
#            NOTE: replace USERNAME with user's name, and IP_ADDRESS obtained
#                  by running the command "ip a" from Arch's command propmt.
#            NOTE: If installing on hardware, probably best not to use ssh,
#                  there is really no need for it.
#            NOTE: If installing in Virtaul Box it is very nice not to use VB's GUI,
#                  however, there are a few caveats:
#                  1. Make sure Networking has been set up for Virtual Machine
#                     using port 3022 as HOST PORT and port 22 as GUEST PORT.
#                  2. On some distros, i noticed this on Linux Mint, I found I
#                     needed to re-generate the ssh keys each time I tried to
#                     log in. This can be done with the following command,
#                     replacing appropriate parts with correct values for your
#                     setup:
#                     ssh-keygen -f "/home/YOUR_USER_NAME/.ssh/known_hosts\ -R "[127.0.0.1]:3022"
#                     NOTE: ip for Virtual Box will usually be 127.0.0.1 on port
#                           3022, unless you manully set it to something else
#                           when setting up port forwarding for the Virtual
#                           Machine.
#                           If Installing on hardware, ip can be obtained by
#                           running the "ip a" command from the Arch Installation
#                           iso's command propmt.
#
# Step 4 (optional): Set keyboard layout (Arch is set up for US keyboard by default)
#         4a. View list of available keyboard layouts with:
#             ls /usr/share/kbd/keymaps/**/*.map.gz
#         4b. To change/set keyboard layout, use "loadkeys" command as follows,
#             replacing LAYOUT with layout file name, minus path and extension:
#             For example, to set to German (example from Arch wiki):
#             loadkeys de-latin1
#
# Step 5: Verify boot mode, i.e. EFI boot or Legacy boot:
#         NOTE: This step will help you determine how the partitions should be
#               setup as it is diffent depending for EFI boot and Legacy boot.
#         5a. ls /sys/firmware/efi/efivars
#         NOTE: If command shows directory without error, then the system is
#         booted in UEFI mode, and the partions will need to be setup for EFI
#         Otherwise the system us booting in Legacy BIOS or CSM, and you will
#         have 2 partitions, one for swap, and one for the rest of the system.
# Step 6: Connect to internet
#         NOTE: If ping was successful earlier than you have internet.
#         NOTE: It is best to use Ethernet for installation.
#         NOTE: Wifi can be set up after install is done if it is needed via
#               steps or Arch wiki @:
#               https://wiki.archlinux.org/index.php/Installation_guide#Connect_to_the_internet
#         NOTE: If you need Wifi during installation follow steps at:
#               https://wiki.archlinux.org/index.php/Installation_guide#Connect_to_the_internet
#         NOTE: The installation image has systemd-networkd.service,
#               systemd-resolved.service and iwd.service enabled by default.
#               That will not be the case for the installed system.
#               In general the configuration of the system run from the iso will
#               not persist to the installed system.
# Step 7: Update the system clock:
#         7a. Run the following command:
#             timedatectl set-ntp true
#         7b. Verify with:
#             timedatectl status
#
# Step 8: Partion the disks:
# -------- Legacy BIOS / CSM --------
#      8a. Identify correct disk using lsblk:
#          lsblk
#      IMPORTANT: Get name of disk right, if you dont you WILL DESTROY DATA on
#                 the mistakenly targeted disk.
#      8b. Partion the appropriate disk via "cfdisk" by running the following
#          command (replace TARGET_DISK_NAME with actual disk name, e.g.,
#          "/dev/sda" or "/dev/sdb", et cetera):
#              cfdisk /dev/TARGET_DISK_NAME
#          CFDISK STEPS:
#          1. Upon running cfdisk /dev/TARGET_DISK_NAME, cfdisk will start with
#             a prompt asking which "Label Type" should be used. For Legacy Boot
#             choose "dos".
#             (Hint: "gpt" is used for UEFI Boot)
#          2. After selecting "Label Type" a GUI is presented, use the "New" menu
#             option to create the  Root partition. This partition should be
#             alloted all available space except for the space you want to allot
#             the SWAP partition. So if you have a 100GB SSD, and you want a 8GB
#             SWAP than the Root partition should be allotted 92GB.
#          3. After specifying space for partition, you will be presented with
#             two options, select "primary", the Root partion MUST be a primary
#             partition. (Hint: SWAP will also be a "primary" partition)
#          4. After selecting "primary" the main GUI will be shown, you MUST
#             make the newly created partion "bootable" by selecting it and
#             selecting the "Bootable" menu option, if sucessful, an "*" will
#             be shown next to the partition in the "Boot" column.
#          5. Repeat steps 2 through 4 for the SWAP partion, alloting the SWAP
#             partition the remaing space on the drive.
#             Hint: For UEFI you would also create a "efi system partition"
#                    alotted at least 512 MB
#          6. For the SWAP, you will need to change it's type by selecting the
#             "Type" menu option, and choosing "82 Linux swap / Solaris" from
#             the list of options.
#
# After completing the above steps, you should have 2 partitions on the disk,
# a Root partition that takes up the majority of the space, and a SWAP partition
# that uses what remains, (Hint: If UEFI you will have a 3rd efi_system_partition)
#
#          9. Write the changes by selecting the "Write" option from the menu,
#             and typing "yes" when prompted.

# Hint: Use "lsblk" command after completing the steps above to make sure
#       everything looks good.
# NOTE: You can also, optionally, create a partition for Home.

# -------- UEFI --------

# Hint: Steps for UEFI are same as for Legacy, with the additional step of
#       crating a efi_system partion.
#
# Step 9: Create the File System
# Hint: ext4 is the most striaght forward to use, it is very stable, and has
#       stood the test of time.
#     9a. To create ext4 file system, use the following command, replacing
#         TARGET_DISK_NAME/PARTION_NAME with actual disk name and partion
#         name, respectivly:
#         mkfs.ext4 /TARGET_DISK_NAME/PARTION_NAME
#         For example, you may have disk /dev/sda with 2 partions:
#             /dev/sda1 (root)
#             /dev/sda2 (swap)
#        So, to format the root partion you would run:
#         mkfs.ext4 /dev/sda1
# NOTE: You do not need to perform step 9 for the SWAP partition, just the Root.
# NOTE: If you created a partition for /home, you need to create a file system
#       for it as well.
#
# Step 10: Make SWAP
#      10a. Run the following command:
#           mkswap /TARGET_DISK_NAME/PARTION_NAME
#      i.e., If the root partition is /dev/sda1
#           mkswap /dev/sda1

# Step 11: Turn SWAP on.
#      11a. Run the following command:
#           swapon /TARGET_DISK_NAME/PARTION_NAME
#      i.e., If the root partition is /dev/sda1
#           swapon /dev/sda1
#
# Step 12: Mount the file system(s):
#      12a. Run the following command:
#           mount /TARGET_DISK_NAME/PARTION_NAME /mnt
#      i.e., If the root partition is /dev/sda1
#           mount /dev/sda1 /mnt
# NOTE: You do not need to mount the SWAP
# NOTE: If you created a partition for /home, you need to mount it AFTER
#       step 13.
# Step 13: Setup /homei and /etc directories on MOUNTED root file system
#      13a. Run the following command:
#           mkdir /mnt/home /mnt/etc
#      13b. "IF" you created a Home partition, you will need to mount it to
#           the newly created /mnt/home directory as follows:
#               mount /TARGET_DISK_NAME/PARTION_NAME /mnt/home
#           i.e., if Home partion is /dev/sda2
#               mount /dev/sda2 /mnt/home
#
# NOTE: The Arch wiki states the next step is to run pacstrap and perform
#       installation, however, some tuturial videos state that you run
#       fstab to generate the fstab file. The video tutorials propbably
#       recomend this so you can fix any errors that occur before installing,
#       it's up to you whether you want to install the generate fstab, or
#       generate fstab and then install, though, a chance to catch errors
#       should not be missed, so this guide assumes genfstab then pacstrap.
#
#  Step 14: Generate fstab file, do this before pacstrap so you can catch errors.
#       14a. Run the following command:
#            genfstab -U -p /mnt >> /mnt/etc/fstab
#       14b. Use cat to verify contests of generated fstab file:
#            cat /mnt/etc/fstab
#
# Step 15: Run pacstrap to perform installation:
# NOTE: You can optionally specify addtional packages you wish to install now,
#
#            For example, to install just essentials (minimum required):
#            pacstrap -i /mnt base linux linux-firmware
#            NOTE: You only need  to install essentials, you can install more
#                  once you chroot  into the new installation after running
#                  pacstrap.
#
#            To install with both lts and current kernals:
#            pacstrap -i /mnt base linux linux-firmware linux-headers linux-lts linux-lts-headers
#            NOTE: Installing both lts and current kernals is good practice, if anything goes
#                  wrong with one the other may be able to be used to regain access to the
#                  system so you can address any issues that are causing problems
#
#            To install with vim and tmux:
#            pacstrap -i /mnt base linux ... vim tmux
#
# NOTE: The -i flag tells pacman to display more information about packages.
# IMPORTANT: After a lot of research, it seems it is good practice to always
#            include the "lts" packages, so a best practice minimum pacstrap
#            would be:
#            pacstrap -i base linux linux-firmware linux-headers linux-lts linux-lts-headers
# My preference, "best practice" minimu pacstrap, then install other packages once
# logged into the new installtion, i.e., after chrooting into it.
#
# Step 16: chroot into new installtion.
#      16a. Run the following command:
#           arch-chroot /mnt
#      You are now logged into your new Arch installation as root : )
#
# Step 17: Set local timezone.
#      17a. Run command:
#           ln -sf /usr/share/zoneinfo/YOUR_REGION/YOUR_CITY /etc/localtime
#      17b. Then generate /etc/adjtime by running command:
#           hwclock --systohc
#
#
# Step 18: Localization (For non-US localizations, you will need to adjust accordingly):
#      18a. Edit file /etc/locale.gen, uncomment or add the following:
#           en_US.UTF-8
#           UTF-8
#      18b. Create locale.conf at /etc/locale.conf and add the following:
#           LANG=en_US.UTF-8
#
# Step 19: Network configuration
#      19a. Create the hostname file at /etc/hostname and add following line
#           replacing HOSTNAME with your desired host name, i.e. name of computer
#      19b. Create/edit hosts file to reflect hostname configuration:
#           vim /etc/hosts should look as follows:
#
#           127.0.0.1  localhost
#           ::1        localhost
#           127.0.0.1  HOSTNAME.localdomain HOSTNAME
#
#           For example, if the HOSTNAME you specified in /etc/hostname is "foo",
#           then /etc/hosts should look like:
#
#           127.0.0.1  localhost
#           ::1        localhost
#           127.0.0.1  foo.localdomain foo

