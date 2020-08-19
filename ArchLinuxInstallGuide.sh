#!/bin/bash

set -o posix

[[ -f "./functions.sh" ]] || printf "\n\nError: functions.sh could not be found\n\n" && exit 1

# Step 1: Download and verify iso | best to use the magnet torrent provided by arch
#         @ https://www.archlinux.org/download/, though this requires a torrent application
#         like qtorrent, it's the most straight forward download, also its kind to leave
#         the torrent client open after so it can be "seeded" back to others downloading
#         the Arch iso via a torrent client. Final note, downloading iso and sig files from
#         ArchLinux.org as opposed to one of the available mirrors is more secure, so if
#         possible, always get directly from ArchLinux.org
#
# The magnet link will be something like:
#
# magnet:?xt=urn:btih:49da7ae0de8874462471d0f5419b850e599b05ef&dn=archlinux-2020.08.01-x86_64.iso
#
# To verify run the following command:
# (make sure to cd to dir where ".iso" and sig are located, ".sig" can be obtained from Arch downloads page mentioned above)
# gpg --keyserver-options auto-key-retrieve --verify archlinux-version-x86_64.iso.sig
#
# Note: If the gpg command above does not work you may need to obtain the appropriate public key, a google search of the error
#       message output by gpg should bring up reddit/stackoverflow/arch wiki posts with appropriate solutions.
# This stack overflow post may also be helpful: https://unix.stackexchange.com/questions/594222/verify-archlinux-signature

# Step 2: Use dd to erase and foramt a usb drive as ext4, then use the following command to put the iso file on the usb stick
# (!MAKE SURE TO cd INTO DIRECTORY WHERE ISO FILE IS BEFORE RUNNING THIS COMMAND)
# sudo dd if=NAMEOF_ISO of=/dev/NAMEOF_DEVICE status="progress"
#
# Note: Use lsblk to get a list of available devices.

# Step 3: With USB plugged in, restart computer (if not already set to boot from usb press F12, or appropriate key to get into Boot Menu)

# Step 4: (optional) Set keyboard layout (Arch is setup for US by default)

# Step 5: Verify the boot mode by running
# ls /sys/firmware/efi/efivars

# Step 6: Confirm internet connection (Always use Ethernet when installing Arch, even if wifi is available,
#         it is more reliable and does not require any set up other than plugging in the cable)
# Just use: ping archlinux.org

# Step 7: Update system clock with following command:
# timedatectl set-ntp true

# Step 8: Set up file system. This step is very important, consult Arch Wiki and google during this step to make sure you do it right.
# Preference: btrfs
# Plan B: Ext4



