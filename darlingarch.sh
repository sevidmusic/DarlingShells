#!/bin/bash

set -o posix

setTextStyleCode() {
  printf "\e[%sm" "${1}"
}

initTextStyles() {
  WARNINGCOLOR=$(setTextStyleCode 35)
  CLEARCOLOR=$(setTextStyleCode 0)
  NOTIFYCOLOR=$(setTextStyleCode 33)
  HIGHLIGHTCOLOR3=$(setTextStyleCode 41)
  USRPRMPTCOLOR=$(setTextStyleCode 41)
  HIGHLIGHTCOLOR=$(setTextStyleCode 41)
  HIGHLIGHTCOLOR2=$(setTextStyleCode 45)
  ATTENTIONEFFECT=$(setTextStyleCode 5)
  ATTENTIONEFFECTCOLOR=$(setTextStyleCode 36)
  DARKTEXTCOLOR=$(setTextStyleCode 30)
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
  printf "%s" "${HIGHLIGHTCOLOR3}"
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
  sleep 0.23
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
    POST_SSH_SETUP_EXIT_MSG="Exiting installer, re-run ${SCRIPTNAME} WTIHOUT the -s flag to continue the installation process"
    SSH_IS_INSTALLED_MSG="SSH is running."
    SSH_LOGIN_AVAILABLE="You can now log into the installation media as root via ssh."
    GETTING_IP_INFO="Getting ip info via ${CLEARCOLOR}${HIGHLIGHTCOLOR}ip a${CLEARCOLOR}"
    POST_SSH_SETUP_MSG="The installer will now exit to give you an oppurtunity to login via ssh."
    SSH_SERVICE_LOCATION_MSG="${SSH:-${OPENSSH}} location and sshd service info:"
}

showBanner()
{
    clear
    printf "\n%s\n" "${BANNER}"
    notifyUser "${1:- }" 0 'dontClear'
}

showIpInfoMsg() {
    notifyUser "${IP_INFO_MSG}" 0 'dontClear'
    notifyUser "${CLEARCOLOR}${HIGHLIGHTCOLOR}$(ip a | grep -E '[0-9][0-9][.][0-9][.][0-9][.][0-9][0-9][0-9]')${CLEARCOLOR}" 0 'dontClear'
    notifyUser "${CLEARCOLOR}${HIGHLIGHTCOLOR2}$(ip a | grep -E '[0-9][0-9][0-9][.][0-9][.][0-9][.][0-9]')${CLEARCOLOR}" 3 'dontClear'
}

showPostSSHInstallMsg() {
    notifyUser "${SSH_LOGIN_AVAILABLE}" 0 'dontClear'
    notifyUser "${POST_SSH_SETUP_MSG}" 0 'dontClear'
}

showSSHLocationService() {
    notifyUser "${SSH_SERVICE_LOCATION_MSG}" 0 'dontClear'
    notifyUser "Location: ${CLEARCOLOR}${HIGHLIGHTCOLOR}$(which ssh)${CLEARCOLOR}" 0 'dontClear'
    notifyUser "Service:  ${CLEARCOLOR}${HIGHLIGHTCOLOR}$(systemctl list-units --type=service | grep ssh | awk '{ print $1 }')${CLEARCOLOR}" 3 'dontClear'
}

showStartSSHExitMsg()
{
    showSSHLocationService
    showIpInfoMsg
    showPostSSHInstallMsg
    showLoadingBar "${POST_SSH_SETUP_EXIT_MSG}" 'dontClear'
    exit 0
}

showDiskInfo()
{
    notifyUser "The following partitions are available" 0 'dontClear'
    notifyUser "${CLEARCOLOR}${HIGHLIGHTCOLOR3}$(fdisk -l | awk '/dev.*Linux/{i++}i==1{print; exit}')${CLEARCOLOR}" 0 'dontClear'
    notifyUser "${CLEARCOLOR}${HIGHLIGHTCOLOR3}$(fdisk -l | awk '/dev.*Linux/{i++}i==2{print; exit}')${CLEARCOLOR}" 3 'dontClear'
}

showDiskModificationWarning()
{
    notifyUser "${CLEARCOLOR}${WARNINGCOLOR}Get this right, ${SCRIPTNAME}${CLEARCOLOR}${WARNINGCOLOR} does not check this for you, if you mis-type this you may loose data!${CLEARCOLOR}" 0 'dontClear'
    showDiskInfo
}

showTimeSettings()
{
    notifyUser "${CLEARCOLOR}${HIGHLIGHTCOLOR}$(timedatectl status | grep 'Local')${CLEARCOLOR}" 0 'dontClear'
    notifyUser "${CLEARCOLOR}${HIGHLIGHTCOLOR2}$(timedatectl status | grep 'Universal')${CLEARCOLOR}" 0 'dontClear'
    notifyUser "${CLEARCOLOR}${HIGHLIGHTCOLOR3}$(timedatectl status | grep 'RTC' | sed 's/[[:space:]]*$//g')${CLEARCOLOR}" 2 'dontClear'
}

installWhich()
{
    showBanner "-- Pre-installation: Installing which --"
    [[ -f ~/.cache/.installer_which ]] && notifyUser "${CLEARCOLOR}${HIGHLIGHTCOLOR}which${CLEARCOLOR}${NOTIFYCOLOR} is already installed: ${CLEARCOLOR}${HIGHLIGHTCOLOR}$(which which)${CLEARCOLOR}" && return
    showLoadingBar "Installing \"which\" so program locations can be determined"
    pacman -S which --noconfirm
    notifyUser "${CLEARCOLOR}${HIGHLIGHTCOLOR}which${CLEARCOLOR}${NOTIFYCOLOR} is now installed on the installation media, this ${CLEARCOLOR}${WARNINGCOLOR}will NOT persist${CLEARCOLOR}${NOTIFYCOLOR} onto the actual installation." 0 'dontClear'
    showLoadingBar "'which' is installed, moving on"
    printf "which_already_installed" >> ~/.cache/.installer_which
}

setRootPassword()
{
    showBanner "-- Pre-installation: Set root password for installation media --"
    [[ -f ~/.cache/.installer_pwd ]] && notifyUser "${PWD_IS_ALREADY_SET}" && return
    notifyUser "${PLS_SET_PWD}" 0 'dontClear'
    passwd || notifyUserAndExit "${PWD_ERROR_OCCURED}" 0 'dontClear' 1
    notifyUser "${PWD_SET_FOR_ISO_WONT_PERSIST}" 0 'dontClear'
    notifyUser "${PWD_SET_FOR_ISO_IS_PWD_FOR_SSH}" 0 'dontClear'
    showLoadingBar "Root password for installation media is set, moving on"
    printf "password_already_set" >> ~/.cache/.installer_pwd
}

startSSH()
{
    showBanner "-- Pre-installation: SSH --"
    if [[ "$(systemctl list-units --type=service | grep ssh | wc -l)" -gt 0 ]]; then
        notifyUser "${SSH} is already running:" 0 'dontClear'
        showStartSSHExitMsg
    fi
    showLoadingBar "${STARTING_SSH_MSG}"
    systemctl start sshd
    [[ "$(systemctl list-units --type=service | grep ssh | wc -l)" -lt 1 ]] && notifyUser "Failed to start sshd. You may need to install/re-install/configure ${SSH}." 0 'dontClear' && exit 1
    notifyUser "${SSH_IS_INSTALLED_MSG}" 0 'dontClear'
    showStartSSHExitMsg
}

installPKGSRequiredByInstaller()
{
    showBanner "-- Pre-installation: Installing packages required by ${SCRIPTNAME}" 0 'dontClear'
    notifyUser "-- Note: These packages will not persist onto actual installation --"
    installWhich
}

syncInstallationMediaTime()
{
    showBanner "-- Pre-installation: Sync installtion media's time --"
    [[ -f ~/.cache/.installer_im_time_sync ]] && notifyUser "Installation media time is already synced:" 0 'dontClear' && showTimeSettings && clear && return
    showLoadingBar "Syncing time settings for installation media" 'dontClear'
    timedatectl set-ntp true || notifyUser "Time seetinggs for installation media were not synced, please re-run ${SCRIPTNAME}" 0 'dontClear'
    notifyUser "Time settings have been updated for installation media:" 2 'dontClear'
    showTimeSettings
    showLoadingBar "Time settings synced for isntallation media, moving on"
    printf "installation_media_time_already_synced" >> ~/.cache/.installer_im_time_sync
}

partitionDisk()
{
    showBanner "-- Pre-installtion: Patition disk --"
    [[ -f ~/.cache/.installer_cfdisk ]] && notifyUser "Disks were already partitioned with cfdisk, to make additional changes run cfdisk again manually." 0 'dontClear' && showDiskInfo && return
    notifyUser "In a moment, cfdisk will start so you can partition the disk. This step is really important, so get it right." 0 'dontClear'
    notifyUser "You will want to partition the disk as follows: (Remember, ${SCRIPTNAME}${CLEARCOLOR}${NOTIFYCOLOR} is designed to install Arch on an ext4 filesystem)" 0 'dontClear'
    notifyUser "Create one partition for SWAP, size should no more than double your available RAM, and at least as much as available RAM." 0 'dontClear'
    notifyUser "Create one partition for root. This should take up the remiander of the available disk space." 0 'dontClear'
    showLoadingBar "Loading cfdisk so you can partition the disk, you will be given an oppurtunity to review the partitions before moving on with the installtion"
    cfdisk /dev/sdb || notifyUserAndExit "${CLEARCOLOR}${WARNINGCOLOR}Warning: cfdisk failed to start, please make sure it is installed then re-run ${SCRIPTNAME}" 0 'dontClear' 1
    clear && notifyUser "Please review the partions you just created, if everything looks good re-run ${SCRIPTNAME}${CLEARCOLOR}${NOTIFYCOLOR} to continue the installtion." 0 'dontClear'
    showDiskInfo
    printf "disks_already_partitioned_to_partition_again_run_cfdisk_manually" >> ~/.cache/.installer_cfdisk
    exit 0
}

makeExt4Filesystem()
{
    showBanner "-- Pre-installtion: Make EXT4 filesystem | User Input Required --"
    [[ -f ~/.cache/.installer_filesystemExt4 ]] && notifyUser "The filesystem was already created on $(cat ~/.cache/.installer_filesystemExt4)" && return
    notifyUser "Please specify the name of the partition you created for ${CLEARCOLOR}${HIGHLIGHTCOLOR3}root${CLEARCOLOR}${NOTIFYCOLOR}:" 0 'dontClear'
    showDiskModificationWarning
    read -p "Partion Name (e.g.${CLEARCOLOR}${HIGHLIGHTCOLOR3}/dev/sdb2${CLEARCOLOR}${NOTIFYCOLOR}):${CLEARCOLOR} " ROOT_PARTITION_NAME
    showLoadingBar "Createing EXT4 filesystem on ${ROOT_PARTITION_NAME}"
    showBanner "-- Pre-installtion: Make EXT4 filesystem --"
    mkfs.ext4 "${ROOT_PARTITION_NAME}" || notifyUserAndExit "The filesystem could not be created on ${ROOT_PARTITION_NAME}" 0 'dontClear' 1
    notifyUser "The filesystem was created successfully" 0 'dontClear'
    showLoadingBar "Ext4 filesystem created, moving on"
    printf "${ROOT_PARTITION_NAME}" >> ~/.cache/.installer_filesystemExt4
}

enableSwap()
{
    showBanner "-- Pre-installtion: Enable SWAP | User Input Required --"
    [[ -f ~/.cache/.installer_swap_enabled ]] && notifyUser "SWAP was already created and enabled on $(cat ~/.cache/.installer_swap_enabled)" && return
    notifyUser "Please specify the name of the partition you created for ${CLEARCOLOR}${HIGHLIGHTCOLOR3}SWAP${CLEARCOLOR}${NOTIFYCOLOR}:" 0 'dontClear'
    showDiskModificationWarning
    read -p "Partion Name (e.g.${CLEARCOLOR}${HIGHLIGHTCOLOR3}/dev/sdb1${CLEARCOLOR}):" SWAP_PARTITION_NAME
    showLoadingBar "Enabling swap via ${CLEARCOLOR}${HIGHLIGHTCOLOR3}mkswap${CLEARCOLOR} and ${CLEARCOLOR}${HIGHLIGHTCOLOR3}swapon${CLEARCOLOR} on partition ${SWAP_PARTITION_NAME}"
    showBanner "-- Pre-installtion: Enable SWAP --"
    mkswap "${SWAP_PARTITION_NAME}" || notifyUserAndExit "Failed to make SWAP" 0 'dontClear' 1
    swapon "${SWAP_PARTITION_NAME}" || notifyUserAndExit "Failed to turn on SWAP" 0 'dontClear' 1
    notifyUser "SWAP was created and enabled successfully"
    printf "${SWAP_PARTITION_NAME}" >> ~/.cache/.installer_swap_enabled
}

mountFilesystem()
{
    showBanner "-- Pre-installtion: Mount filesystem | User Input Required --"
    [[ -f ~/.cache/.installer_filesystem_mounted ]] && notifyUser "Filesystem was already mounted from $(cat ~/.cache/.installer_filesystem_mounted)" && return
    notifyUser "Please specify the name of the partition you created for ${CLEARCOLOR}${HIGHLIGHTCOLOR3}root${CLEARCOLOR}${NOTIFYCOLOR}:" 0 'dontClear'
    showDiskModificationWarning
    read -p "Partion Name (e.g.${CLEARCOLOR}${HIGHLIGHTCOLOR3}/dev/sdb2${CLEARCOLOR}):" ROOT_PARTITION_NAME
    showLoadingBar "Mounting root filesystem from ${ROOT_PARTITION_NAME} "
    showBanner "-- Pre-installtion: Mount filesystem --"
    mount "${ROOT_PARTITION_NAME}" /mnt || notifyUserAndExit "Failed to mount ${ROOT_PARTITION_NAME}, please re-run ${SCRIPTNAME}${CLEARCOLOR}${NOTIFYCOLOR} and try again." 0 'dontClear' 1
    notifyUser "Filesystem was mounted successfully at /mnt"
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
      notifyUser "The -p flag can be used to specify a package file:" 0 'dontClear'
      notifyUser "${SCRIPTNAME}${CLEARCOLOR}${HIGHLIGHTCOLOR3} -p /path/to/file${CLEARCOLOR}" 0 'dontClear'
      notifyUser "Any packages named in the specified file will be included in the final insallation." 0 'dontClear'
      # -s
      notifyUser "The -s flag will cause ${SCRIPTNAME}${CLEARCOLOR}${NOTIFYCOLOR} to attempt to start ssh via ${CLEARCOLOR}${HIGHLIGHTCOLOR3}systemctl start sshd${CLEARCOLOR}" 0 'dontClear'
      notifyUser "${SCRIPTNAME}${CLEARCOLOR}${HIGHLIGHTCOLOR3} -s${CLEARCOLOR}" 0 'dontClear'
      notifyUser "openssh MUST be installed for -s to work." 0 'dontClear'
      # -l
      notifyUser "The -l flag will cause ${SCRIPTNAME}${CLEARCOLOR}${NOTIFYCOLOR} to print a log of all the messages shown while the script was running." 0 'dontClear'
      notifyUser "${SCRIPTNAME}${CLEARCOLOR}${HIGHLIGHTCOLOR3} -l${CLEARCOLOR}" 0 'dontClear'
      notifyUser "The -l flag is helpful if you need to review what ${SCRIPTNAME}${CLEARCOLOR}${NOTIFYCOLOR} has done so far." 0 'dontClear'
}

showHelpMsg()
{
      notifyUser "${HELP_MSG_WELCOME1}" 0 'dontClear'
      notifyUser "${HELP_MSG_WELCOME2}" 0 'dontClear'
      notifyUser "${HELP_MSG_WELCOME3}" 0 'dontClear'
      notifyUser "${HELP_MSG_WELCOME4}" 0 'dontClear'
      showFlagInfo
}
########################## PROGRAM #######################

clear
initTextStyles
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
      [[ -f ~/.cache/.installer_msg_log ]] || notifyUserAndExit "There are no logged messages" 0 'dontClear'
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

