#!/bin/bash

set -o posix

setColor() {
  printf "\e[%sm" "${1}"
}

initColors() {
  WARNINGCOLOR=$(setColor 35)
  CLEARCOLOR=$(setColor 0)
  NOTIFYCOLOR=$(setColor 33)
  HIGHLIGHTCOLOR3=$(setColor 41)
  USRPRMPTCOLOR=$(setColor 41)
  HIGHLIGHTCOLOR=$(setColor 41)
  HIGHLIGHTCOLOR2=$(setColor 45)
  ATTENTIONEFFECT=$(setColor 5)
  ATTENTIONEFFECTCOLOR=$(setColor 36)
  DARKTEXTCOLOR=$(setColor 30)
}

animatedPrint()
{
  local _charsToAnimate _speed _currentChar _charCount
  # For some reason spaces get mangled using ${VAR:POS:LIMIT}. so replace spaces with _ here,
  # then add spaces back when needed.
  _charsToAnimate=$( printf "%s" "${1}" | sed -E "s/ /_/g;")
  _speed="${2:-0.05}"
  _charCount=0
  for (( i=0; i< ${#_charsToAnimate}; i++ )); do
      ((_charCount++))
      [[ $_charCount == $((_slb_adjustedNumChars - 10)) ]] && _charCount=0 && printf "\n\n "
      # Replace placeholder _ with space | i.e., fix spaces that were replaced
      _currentChar=$(printf "%s" "${_charsToAnimate:$i:1}" | sed -E "s/_/ /g;")
      printf "%s" "${_currentChar}"
      sleep $_speed
  done
}

showLoadingBar() {
  local _slb_inc _slb_windowWidth _slb_numChars _slb_adjustedNumChars _slb_loadingBarLimit
  printf "\n"
  animatedPrint "${1}" .05
  setColor 43
  _slb_inc=0
  _slb_windowWidth=$(tput cols)
  _slb_numChars="${#1}"
  _slb_adjustedNumChars=$((_slb_windowWidth - _slb_numChars))
  _slb_loadingBarLimit=$((_slb_adjustedNumChars - 10))
  while [[ ${_slb_inc} -le "${_slb_loadingBarLimit}" ]]; do
    animatedPrint ":" .007
    _slb_inc=$((_slb_inc + 1))
  done
  printf " %s\n" "${CLEARCOLOR}${ATTENTIONEFFECT}${ATTENTIONEFFECTCOLOR}[100%]${CLEARCOLOR}"
  setColor 0
  sleep 1
  [[ "${2}" != "dontClear" ]] && clear
}

notifyUser()
{
    printf "\n${CLEARCOLOR}${NOTIFYCOLOR}"
    animatedPrint "${1}" 0.009
    sleep ${2:-2}
    [[ "${3}" == "dontClear" ]] || clear
    printf "${CLEARCOLOR}\n"
    printf "\n%s\n" "${1}" >> ~/.cache/.installer_msg_log
}

notifyUserAndExit()
{
    notifyUser "${1}" "${2:-1}" "${3:-CLEAR}"
    exit "${4:-0}"
}

initMessages() {
    NEWLINE="\n\n"
    SCRIPT=`basename "$(realpath $0)"`
    SCRIPTNAME="${CLEARCOLOR}${HIGHLIGHTCOLOR}${SCRIPT}${CLEARCOLOR}"
    OPENSSH="${CLEARCOLOR}${HIGHLIGHTCOLOR}openssh${CLEARCOLOR}${NOTIFYCOLOR}"
    BANNER='
   ___           ___             ___           __
  / _ \___ _____/ (_)__  ___ _  / _ | ________/ /
 / // / _ \/ __/ / / _ \/ _  / / __ |/ __/ __/ _ \
/____/\_._/_/ /_/_/_//_/\_. / /_/ |_/_/  \__/_//_/
                       /___/
'
    HELP_MSG_WELCOME1="I developed ${SCRIPTNAME}${CLEARCOLOR}${NOTIFYCOLOR} as a guide for myself."
    HELP_MSG_WELCOME2="It walks me through the process of installing Arch linux on a legacy BIOS using ext4 for a filesystem."
    HELP_MSG_WELCOME3="Feel free to modify the script to suit your needs."
    HELP_MSG_WELCOME4="-Sevi D"
    LB_PRE_INSTALL_MSG='Pre-installation will begin in a moment'
    LB_INSTALL_MSG='Insallation of Arch Linx will begin in a moment'
    LB_POST_INSTALL_MSG='Post-installation will being in a moment'
    PWD_IS_ALREADY_SET="Root password was already set, to reset run: ${CLEARCOLOR}${HIGHLIGHTCOLOR2}passwd${CLEARCOLOR}"
    PLS_SET_PWD="Please set the root password:"
    PWD_ERROR_OCCURED="${CLEARCOLOR}${WARNINGCOLOR}An error occured, please re-run ${SCRIPTNAME}"
    PWD_SET_FOR_ISO_WONT_PERSIST="${CLEARCOLOR}${WARNINGCOLOR}The password you just set will NOT persist onto the actual installation.${CLEARCOLOR}"
    PWD_SET_FOR_ISO_IS_PWD_FOR_SSH="If the -s flag was supplied, then the password you just set will be the password you use to login to the installation media as root via ssh."
    IP_INFO_MSG="The following is your ip info (obtained via ${CLEARCOLOR}${HIGHLIGHTCOLOR}ip a${CLEARCOLOR}${NOTIFYCOLOR}):"
    STARTING_SSH_MSG="Attempting to start sshd"
    POST_SSH_INSTALL_EXIT_MSG="Exiting installer, re-run WTIHOUT -s flag to continue with installation"
    SSH_IS_INSTALLED_MSG="SSH is running."
    SSH_LOGIN_AVAILABLE="You can now log into the installation media as root via ssh."
    GETTING_IP_INFO="Getting ip info via ${CLEARCOLOR}${HIGHLIGHTCOLOR}ip a${CLEARCOLOR}"
    POST_SSH_OPENING_MSG1="The installer will now exit to give you an oppurtunity to login via ssh."
    POST_SSH_OPENING_MSG2="Whether or not you decide to login via ssh, to continue the installation process re-run ${SCRIPTNAME}${CLEARCOLOR}${NOTIFYCOLOR} without the -s flag:"
    SSH_SERVICE_LOCATION_MSG="${SSH:-${OPENSSH}} location and sshd service info:"
}

showBanner()
{
    printf "\n%s\n" "${BANNER}"
    notifyUser "${1:- }" 1 'dontClear'
}

showIpInfoMsg() {
    showLoadingBar "${GETTING_IP_INFO}" 'dontClear'
    notifyUser "${IP_INFO_MSG}" 1 'dontClear'
    notifyUser "${CLEARCOLOR}${HIGHLIGHTCOLOR}$(ip a | grep -E '[0-9][0-9][.][0-9][.][0-9][.][0-9][0-9][0-9]')${CLEARCOLOR}" 1 'dontClear'
    notifyUser "${CLEARCOLOR}${HIGHLIGHTCOLOR2}$(ip a | grep -E '[0-9][0-9][0-9][.][0-9][.][0-9][.][0-9]')${CLEARCOLOR}" 3 'dontClear'
}

showPostSSHInstallMsg() {
    notifyUser "${SSH_LOGIN_AVAILABLE}" 1 'dontClear'
    notifyUser "${POST_SSH_OPENING_MSG1}" 1 'dontClear'
    notifyUser "${POST_SSH_OPENING_MSG2}" 1 'dontClear'
    notifyUser "Example:" 1 'dontClear'
    notifyUser "${SCRIPTNAME}" 1 'dontClear'
    notifyUser "or" 1 'dontClear'
    notifyUser "${SCRIPTNAME}${CLEARCOLOR}${HIGHLIGHTCOLOR} -p /path/to/packagefile${CLEARCOLOR}" 1 'dontClear'

}

showSSHLocationService() {
    notifyUser "${SSH_SERVICE_LOCATION_MSG}" 1 'dontClear'
    notifyUser "Location: ${CLEARCOLOR}${HIGHLIGHTCOLOR}$(which ssh)${CLEARCOLOR}" 1 'dontClear'
    notifyUser "Service:  ${CLEARCOLOR}${HIGHLIGHTCOLOR}$(systemctl list-units --type=service | grep ssh | awk '{ print $1 }')${CLEARCOLOR}" 3 'dontClear'
}

showStartSSHExitMsg()
{
    showSSHLocationService
    showIpInfoMsg
    showPostSSHInstallMsg
    showLoadingBar "${POST_SSH_INSTALL_EXIT_MSG}"
    exit 0
}

showDiskModificationWarning()
{
    notifyUser "${CLEARCOLOR}${WARNINGCOLOR}Get this right, ${SCRIPTNAME}${CLEARCOLOR}${WARNINGCOLOR} does not check this for you, if you mis-type this you may loose data!${CLEARCOLOR}" 1 'dontClear'
    lsblk
}

showTimeSettings()
{
    notifyUser "$(timedatectl status | grep 'Local')" 1 'dontClear'
    notifyUser "$(timedatectl status | grep 'Universal')" 1 'dontClear'
    notifyUser "$(timedatectl status | grep 'RTC')" 2 'dontClear'
}

installWhich()
{
    [[ -f ~/.cache/.installer_which ]] && printf "${NEWLINE}" && notifyUser "${CLEARCOLOR}${HIGHLIGHTCOLOR}which${CLEARCOLOR}${NOTIFYCOLOR} is already installed: ${CLEARCOLOR}${HIGHLIGHTCOLOR}$(which which)${CLEARCOLOR}" && return
    showLoadingBar "Installing \"which\" so program locations can be determined"
    pacman -S which --noconfirm
    notifyUser "${CLEARCOLOR}${HIGHLIGHTCOLOR}which${CLEARCOLOR}${NOTIFYCOLOR} is now installed on the installation media, this ${CLEARCOLOR}${WARNINGCOLOR}will NOT persist${CLEARCOLOR}${NOTIFYCOLOR} onto the actual installation."
    printf "which_already_installed" >> ~/.cache/.installer_which
}

setRootPassword()
{
    showBanner "-- Pre-installation: Set root password for installation media --"
    [[ -f ~/.cache/.installer_pwd ]] && notifyUser "${PWD_IS_ALREADY_SET}" && return
    notifyUser "${PLS_SET_PWD}" 1 'dontClear'
    passwd || notifyUserAndExit "${PWD_ERROR_OCCURED}" 1 'dontClear' 1
    notifyUser "${PWD_SET_FOR_ISO_WONT_PERSIST}" 1 'dontClear'
    notifyUser "${PWD_SET_FOR_ISO_IS_PWD_FOR_SSH}" 3
    printf "password_already_set" >> ~/.cache/.installer_pwd
}

startSSH()
{
    showBanner "-- Pre-installation: SSH --"
    if [[ "$(systemctl list-units --type=service | grep ssh | wc -l)" -gt 0 ]]; then
        notifyUser "${SSH} is already running:" 1 'dontClear'
        showStartSSHExitMsg
    fi
    showLoadingBar "${STARTING_SSH_MSG}"
    systemctl start sshd
    [[ "$(systemctl list-units --type=service | grep ssh | wc -l)" -lt 1 ]] && notifyUser "Failed to start sshd. You may need to install/re-install/configure ${SSH}." 1 'dontClear' && exit 1
    notifyUser "${SSH_IS_INSTALLED_MSG}" 1 'dontClear'
    showStartSSHExitMsg
}

installPKGSRequiredByInstaller()
{
    showBanner "-- Pre-installation: Installing packages need by ${SCRIPTNAME}. These will not persist onto actual installation --"
    installWhich
}

syncInstallationMediaTime()
{
    showBanner "-- Pre-installation: Sync installtion media's time --"
    [[ -f ~/.cache/.installer_im_time_sync ]] && notifyUser "Installation media time is already synced:" 1 'dontClear' && showTimeSettings && clear && return
    showLoadingBar "Syncing time settings for installation media" 'dontClear'
    timedatectl set-ntp true || notifyUser "Time seetinggs for installation media were not synced, please re-run ${SCRIPTNAME}" 1 'dontClear'
    notifyUser "Time settings have been updated for installation media:" 2 'dontClear'
    showTimeSettings
    clear
    printf "installation_media_time_already_synced" >> ~/.cache/.installer_im_time_sync
}

partitionDisk()
{
    showBanner "-- Pre-installtion: Patition disk --"
    [[ -f ~/.cache/.installer_cfdisk ]] && notifyUser "Disks were already partitioned with cfdisk, to make additional changes run cfdisk again manually." && return
    notifyUser "In a moment, cfdisk will start so you can partition the disk. This step is really important, so get it right." 1 'dontClear'
    notifyUser "You will want to partition the disk as follows: (Remember, ${SCRIPTNAME}${CLEARCOLOR}${NOTIFYCOLOR} is designed to install Arch on an ext4 filesystem)" 1 'dontClear'
    notifyUser "Create one partition for SWAP, size should no more than double your available RAM, and at least as much as available RAM." 1 'dontClear'
    notifyUser "Create one partition for root. This should take up the remiander of the available disk space." 1 'dontClear'
    showLoadingBar "Loading cfdisk so you can partition the disk, you will be given an oppurtunity to review the partitions before moving on with the installtion"
    cfdisk /dev/sdb || notifyUserAndExit "${CLEARCOLOR}${WARNINGCOLOR}Warning: cfdisk failed to start, please make sure it is installed then re-run ${SCRIPTNAME}" 1 'dontClear' 1
    clear && notifyUser "Please review the partions you just created, if everything looks good re-run ${SCRIPTNAME}${CLEARCOLOR}${NOTIFYCOLOR} to continue the installtion." 1 'dontClear'
    notifyUser "The following disk overview was obtained with ${CLEARCOLOR}${HIGHLIGHTCOLOR3}lsblk${CLEARCOLOR}${NOTIFYCOLOR}" 1 'dontClear'
    lsblk
    printf "disks_already_partitioned_to_partition_again_run_cfdisk_manually" >> ~/.cache/.installer_cfdisk
    exit 0
}

makeExt4Filesystem()
{
    showBanner "-- Pre-installtion: Make EXT4 filesystem --"
    [[ -f ~/.cache/.installer_filesystemExt4 ]] && notifyUser "The filesystem was already created on $(cat ~/.cache/.installer_filesystemExt4)" && return
    notifyUser "Please specify the name of the partition you created for ${CLEARCOLOR}${HIGHLIGHTCOLOR3}root${CLEARCOLOR}${NOTIFYCOLOR}:" 1 'dontClear'
    showDiskModificationWarning
    read -p "Partion Name (e.g.${CLEARCOLOR}${HIGHLIGHTCOLOR3}/dev/sdb2${CLEARCOLOR}${NOTIFYCOLOR}):${CLEARCOLOR} " ROOT_PARTITION_NAME
    showLoadingBar "Createing EXT4 filesystem on ${ROOT_PARTITION_NAME}"
    # make ext4 filesystem on root partition
    mkfs.ext4 "${ROOT_PARTITION_NAME}"
    showLoadingBar "The filesystem was created successfully"
    printf "${ROOT_PARTITION_NAME}" >> ~/.cache/.installer_filesystemExt4
}

enableSwap()
{
    showBanner "-- Pre-installtion: Enable SWAP --"
    [[ -f ~/.cache/.installer_swap_enabled ]] && notifyUser "SWAP was already created and enabled on $(cat ~/.cache/.installer_swap_enabled)" && return
    notifyUser "Please specify the name of the partition you created for ${CLEARCOLOR}${HIGHLIGHTCOLOR3}SWAP${CLEARCOLOR}${NOTIFYCOLOR}:" 1 'dontClear'
    showDiskModificationWarning
    read -p "Partion Name (e.g.${CLEARCOLOR}${HIGHLIGHTCOLOR3}/dev/sdb1${CLEARCOLOR}):" SWAP_PARTITION_NAME
    showLoadingBar "Enabling swap via ${CLEARCOLOR}${HIGHLIGHTCOLOR3}mkswap${CLEARCOLOR} and ${CLEARCOLOR}${HIGHLIGHTCOLOR3}swapon${CLEARCOLOR} on partition ${SWAP_PARTITION_NAME}"
    mkswap "${SWAP_PARTITION_NAME}"
    swapon "${SWAP_PARTITION_NAME}"
    printf "${SWAP_PARTITION_NAME}" >> ~/.cache/.installer_swap_enabled
}

mountFilesystem()
{
    showBanner "-- Pre-installtion: Mount filesystem --"
    [[ -f ~/.cache/.installer_filesystem_mounted ]] && notifyUser "Filesystem was already mounted from $(cat ~/.cache/.installer_filesystem_mounted)" && return
    notifyUser "Please specify the name of the partition you created for ${CLEARCOLOR}${HIGHLIGHTCOLOR3}root${CLEARCOLOR}${NOTIFYCOLOR}:" 1 'dontClear'
    showDiskModificationWarning
    read -p "Partion Name (e.g.${CLEARCOLOR}${HIGHLIGHTCOLOR3}/dev/sdb2${CLEARCOLOR}):" ROOT_PARTITION_NAME
    showLoadingBar "Mounting root filesystem from ${ROOT_PARTITION_NAME} "
    mount "${ROOT_PARTITION_NAME}" /mnt || notifyUserAndExit "Failed to mount ${ROOT_PARTITION_NAME}, please re-run ${SCRIPTNAME} and try again."
    printf "${ROOT_PARTITION_NAME}" >> ~/.cache/.installer_filesystem_mounted
}

performPreInsallation() {
    showBanner "-- Pre-installation --"
    showLoadingBar "${LB_PRE_INSTALL_MSG}"
    installPKGSRequiredByInstaller
    setRootPassword
    [[ -n "${SSH}" ]] && startSSH
    syncInstallationMediaTime
    partitionDisk
    makeExt4Filesystem
    enableSwap
    mountFilesystem
}

performInstallation() {
    showBanner "-- Installation --"
    showLoadingBar "${LB_INSTALL_MSG}"
}

performPostInstallation() {
    showBanner "-- Post-installation --"
    showLoadingBar "${LB_POST_INSTALL_MSG}"
}

showFlagInfo()
{
      showLoadingBar "Loading flag info"
      showBanner "-- Help: Flags --"
      # -p
      notifyUser "The -p flag can be used to specify a package file:" 1 'dontClear'
      notifyUser "${SCRIPTNAME}${CLEARCOLOR}${HIGHLIGHTCOLOR3} -p /path/to/file${CLEARCOLOR}" 1 'dontClear'
      notifyUser "Any packages named in the specified file will be included in the final insallation." 1 'dontClear'
      # -s
      notifyUser "The -s flag will cause ${SCRIPTNAME}${CLEARCOLOR}${NOTIFYCOLOR} to attempt to start ssh via ${CLEARCOLOR}${HIGHLIGHTCOLOR3}systemctl start sshd${CLEARCOLOR}" 1 'dontClear'
      notifyUser "${SCRIPTNAME}${CLEARCOLOR}${HIGHLIGHTCOLOR3} -s${CLEARCOLOR}" 1 'dontClear'
      notifyUser "openssh MUST be installed for -s to work." 1 'dontClear'
      # -l
      notifyUser "The -l flag will cause ${SCRIPTNAME}${CLEARCOLOR}${NOTIFYCOLOR} to print a log of all the messages shown while the script was running." 1 'dontClear'
      notifyUser "${SCRIPTNAME}${CLEARCOLOR}${HIGHLIGHTCOLOR3} -l${CLEARCOLOR}" 1 'dontClear'
      notifyUser "The -l flag is helpful if you need to review what ${SCRIPTNAME}${CLEARCOLOR}${NOTIFYCOLOR} has done so far." 1 'dontClear'
}

showHelpMsg()
{
      notifyUser "${HELP_MSG_WELCOME1}" 1 'dontClear'
      notifyUser "${HELP_MSG_WELCOME2}" 1 'dontClear'
      notifyUser "${HELP_MSG_WELCOME3}" 1 'dontClear'
      notifyUser "${HELP_MSG_WELCOME4}" 1 'dontClear'
      showFlagInfo
}
########################## PROGRAM #######################

clear
initColors
initMessages
# For a great article on getopts, and other approaches to handling bash arguments:
# @see https://wiki.bash-hackers.org/howto/getopts_tutorial
while getopts ":hsl" OPTION; do
  case "${OPTION}" in
  h)
      showBanner "-- Help --"
      showHelpMsg
      notifyUserAndExit "Exiting installer"
      exit 1
    ;;
  s)
      SSH="${OPENSSH}"
    ;;
  l)
      [[ -f ~/.cache/.installer_msg_log ]] || notifyUserAndExit "There are no logged messages" 1 'dontClear'
      cat ~/.cache/.installer_msg_log | more
      exit 0
    ;;
  \?)
     animatedPrint "Invalid argument: -${OPTARG}" && exit 1
    ;;
  esac
done
clear
performPreInsallation
# NOTE: Use a file to determine which packages are installed in addition to base. i.e. package.list
performInstallation
performPostInstallation





