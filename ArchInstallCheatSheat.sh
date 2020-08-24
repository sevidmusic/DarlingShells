#!/bin/bash

set -o posix

######################################################################################
######################################################################################
# I created this script as a guide to installing Arch.
#
# Mostly of this script is comprised of doc comments with details about
# each step of the Arch installation process.
#
# It is also designed as a simple installer, i.e. if run, it will guide
# you through and perform the neccesary operations required to install Arch.
#
# This guide asssumes a USB is ready with a verified Arch Linux iso on it.
######################################################################################
######################################################################################
# Virtual Box Specific Steps
######################################################################################
######################################################################################
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
#        (Note: On some distros vboxmanage is VBoxManage)
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
######################################################################################
#    1. If you plan to use ssh, you need to setup port forwarding, do this before
#       starting the machine.
#            1a. In "Settings" for Virtual Machine go to "Network" tab
#            1b. Open the "Advanced" drop down
#            1c. Click the "Port Forwarding" button
#            1d. In the pop up window, click the "+" icon to add a new rule
#            1e. Leave everything blank except for following:
#                 - Host Port: 3022
#                 - Guest Port: 22
######################################################################################
######################################################################################
######################################################################################
######################################################################################

######################################################################################
########################## Arch Installation Steps ###################################
######################################################################################
# Note: You will need to make sure to access bios and boot from the USB, press
#       F12, or whatever is appropriate for your motherboard, to access bios on
#       startup.
# Note: If running in Virtual Box, the Arch iso will automatically boot into Arch
#       when you start the Virtual Machine.
# Note: If running in Virtual Box make sure to perform steps specific to Virtual
#       Box prior to starting the Virtual Machine
# IMPORTANT NOTE: All changes made while logged into arch iso, i.e. pre installation,
#                 WILL NOT persist to actual installation, i.e., if you install vim
#                 before running "arch-chroot /mnt" vim will not exist on the actual
#                 installation.
######################################################################################
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
#            Note: "passwd" when run as root will allow you to set a new root
#                  password via a simple propmt. This is the password you will
#                  use to login as root via ssh.
#        3d. Open a terminal on HOST MACHINE, and run following command:
#            ssh USERNAME@IP_ADDRESS
#            Note: replace USERNAME with user's name, and IP_ADDRESS obtained
#                  by running the command "ip a" from Arch's command propmt.
#            Note: If installing on hardware, probably best not to use ssh,
#                  there is really no need for it.
#            Note: If installing in Virtaul Box it is very nice not to use VB's GUI,
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
#          "/dev/sda" or "/dev/sdb", et ceterai):
#              cfdisk /dev/TARGET_DISK_NAME
#          CFDISK STEPS:
#          1. Upon running cfdisk /dev/TARGET_DISK_NAME, cfdisk will start with
#             a prompt asking which "Label Type" should be used, for Legacy Boot
#             choose "dos".
#             (Hint: "gpt" is used for UEFI Boot)
#          2. After selecting "Label Type" a GUI is presented, use the "New" menu
#             option to create the  Root partition. This partition should be
#             alloted all available space except for the space you want to allot
#             the SWAP partition. So if you have a 100GB SSD, and you want a 8GB
#             SWAP than the Root partition should be allotted 92GB.
#          3. After specifying space for partition, you will be presented with
#             two options, select "primary", the Root partion MUST be a primary
#             partition.
#          4. After selecting "primary" the main GUI will be shown, make sure
#             to make the newly created partion "bootable" by selecting it and
#             selecting the "Bootable" menu option, if sucessful, an "*" will
#             be shown next to the partition in the "Boot" column.
#          5. Repeat steps 2 through 4 for the SWAP partion, alloting the SWAP
#             partition the remaing space on the drive.
#          6. For the SWAP, you will need to change it's type by selecting the
#             "Type" menu option, and choosing "82 Linux swap / Solaris" from
#             the list of options.
# After completing the above steps, you should have 2 partitions on the disk,
# a Root partition that takes up the majority of the space, and a SWAP partition
# that uses what remains,
#          9. Write the changes by selecting the "Write" option from the menu,
#             and typing "yes" when prompted.
# Hint: Use lsblk agter completing the steps above to make sure everything
#       looks good.

