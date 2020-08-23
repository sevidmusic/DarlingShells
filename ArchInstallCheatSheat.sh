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
######################################################################################






