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

initMessages() {
    NEWLINE="\n\n"
    SCRIPTNAME=`basename "$(realpath $0)"`
    BANNER='
   ___           ___             ___           __
  / _ \___ _____/ (_)__  ___ _  / _ | ________/ /
 / // / _ \/ __/ / / _ \/ _  / / __ |/ __/ __/ _ \
/____/\_._/_/ /_/_/_//_/\_. / /_/ |_/_/  \__/_//_/
                       /___/
'
    HELPMSG_OPENING1="I developed ${CLEARCOLOR}${HIGHLIGHTCOLOR}${SCRIPTNAME}${CLEARCOLOR}${NOTIFYCOLOR} as a guide for myself."
    HELPMSG_OPENING2="It walks me through the process of installing Arch linux on a legacy BIOS using ext4 for a filesystem."
    HELPMSG_CLOSING1="Feel free to modify the script to suit your needs."
    HELPMSG_CLOSING2="-Sevi D"
    LB_PRE_INSTALL_MSG='Pre-installation will begin in a moment'
    LB_INSTALL_MSG='Insallation of Arch Linx will begin in a moment'
    LB_POST_INSTALL_MSG='Post-installation will being in a moment'
    PWD_ISSET="Root password was already set, to reset run: ${CLEARCOLOR}${HIGHLIGHTCOLOR2}passwd${CLEARCOLOR}"
    PLS_SET_PWD="Please set the root password:"
    PWD_ERROR_OCCURED="${CLEARCOLOR}${WARNINGCOLOR}An error may have occured, you may need to manually set the root password for the installation media by running: ${CLEARCOLOR}${HIGHLIGHTCOLOR3}passwd${CLEARCOLOR}"
    PWD_WAS_SET_FOR_ISO_WONT_PERSIST="${CLEARCOLOR}${WARNINGCOLOR}The password you just set will NOT persist onto the actual installation.${CLEARCOLOR}"
    PWD_WAS_SET_USE_FOR_SSH_LOGIN="If the -s flag was supplied, then the password you just set will be the password you use to login to the installation media as root via ssh."
    IPINFOMSG1="The following is your ip info (obtained via ${CLEARCOLOR}${HIGHLIGHTCOLOR}ip a${CLEARCOLOR}${NOTIFYCOLOR}):"
    STARTING_SSH_MSG="Attempting to start sshd"
    POST_SSH_INSTALL_EXIT_MSG="Exiting installer, re-run WTIHOUT -s flag to continue with installation"
    SSH_LOGIN_AVAILABLE="You can now log into the installation media as root via ssh."
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
}

setRootPassword()
{
    [[ -f ~/.cache/.installer_pwd ]] && notifyUser "${PWD_ISSET}" && return
    notifyUser "${PLS_SET_PWD}" 1 'dontClear'
    passwd || notifyUser "${PWD_ERROR_OCCURED}" 1 'dontClear'
    notifyUser "${PWD_WAS_SET_FOR_ISO_WONT_PERSIST}" 1 'dontClear'
    notifyUser "${PWD_WAS_SET_USE_FOR_SSH_LOGIN}" 3
    printf "passwor_already_set" >> ~/.cache/.installer_pwd
}

showIpInfoMsg() {
    showLoadingBar "Getting ip info via ${CLEARCOLOR}${HIGHLIGHTCOLOR}ip a${CLEARCOLOR}"
    notifyUser "${IPINFOMSG1}" 1 'dontClear'
    notifyUser "${CLEARCOLOR}${HIGHLIGHTCOLOR}$(ip a | grep -E '[0-9][0-9][.][0-9][.][0-9][.][0-9][0-9][0-9]')${CLEARCOLOR}" 1 'dontClear'
    notifyUser "${CLEARCOLOR}${HIGHLIGHTCOLOR2}$(ip a | grep -E '[0-9][0-9][0-9][.][0-9][.][0-9][.][0-9]')${CLEARCOLOR}" 3 'dontClear'
}

showPostSSHInstallMsg() {
    notifyUser "${SSH_LOGIN_AVAILABLE}" 1 'dontClear'
    notifyUser "The installer will now exit to give you an oppurtunity to login via ssh." 1 'dontClear'
    notifyUser "Whether or not you decide to login via ssh, to continue the installation process re-run ${CLEARCOLOR}${HIGHLIGHTCOLOR3}${SCRIPTNAME}${CLEARCOLOR}${NOTIFYCOLOR} without the -s flag:" 1 'dontClear'
    notifyUser "Example:" 1 'dontClear'
    notifyUser "${CLEARCOLOR}${HIGHLIGHTCOLOR}${SCRIPTNAME}${CLEARCOLOR}" 1 'dontClear'
    notifyUser "or" 1 'dontClear'
    notifyUser "${CLEARCOLOR}${HIGHLIGHTCOLOR}${SCRIPTNAME} -p /path/to/packagefile${CLEARCOLOR}" 1 'dontClear'

}

showSSHLocationService() {
    notifyUser "${SSH} location and sshd service info:" 1 'dontClear'
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

startSSH()
{
    if [[ "$(systemctl list-units --type=service | grep ssh | wc -l)" -gt 0 ]]; then
        notifyUser "${CLEARCOLOR}${HIGHLIGHTCOLOR}${SSH}${CLEARCOLOR}${NOTIFYCOLOR} is already running:" 1 'dontClear'
        showStartSSHExitMsg
    fi
    showLoadingBar "${STARTING_SSH_MSG}"
    systemctl start sshd
    [[ "$(systemctl list-units --type=service | grep ssh | wc -l)" -lt 1 ]] && printf "${NEWLINE}" && animatedPrint "Failed to start sshd. You may need to install/re-install/configure ${SSH}." && exit 1
    notifyUser "SSH is now running, you should now be able to login via ssh"
    showStartSSHExitMsg
}


installWhich() {
    [[ -f ~/.cache/.installer_which ]] && printf "${NEWLINE}" && notifyUser "${CLEARCOLOR}${HIGHLIGHTCOLOR}which${CLEARCOLOR}${NOTIFYCOLOR} is already installed: ${CLEARCOLOR}${HIGHLIGHTCOLOR}$(which which)${CLEARCOLOR}" && return
    showLoadingBar "Installing \"which\" so program locations can be determined"
    pacman -S which --noconfirm
    notifyUser "${CLEARCOLOR}${HIGHLIGHTCOLOR}which${CLEARCOLOR}${NOTIFYCOLOR} is now installed on the installation media, this ${CLEARCOLOR}${WARNINGCOLOR}will NOT persist${CLEARCOLOR}${NOTIFYCOLOR} onto the actual installation."
    printf "which_already_installed" >> ~/.cache/.installer_which
}

installPKGSForInstaller()
{
    installWhich
}

performPreInsallation() {
    printf "%s" "${BANNER}"
    showLoadingBar "${LB_PRE_INSTALL_MSG}"
    installPKGSForInstaller
    setRootPassword
    [[ -n "${SSH}" ]] && startSSH
}

performInstallation() {
    showLoadingBar "${LB_INSTALL_MSG}"
}

performPostInstallation() {
    showLoadingBar "${LB_POST_INSTALL_MSG}"
}

showHelpMsg()
{
      notifyUser "${HELPMSG_OPENING1}" 1 'dontClear'
      notifyUser "${HELPMSG_OPENING2}" 1 'dontClear'
      notifyUser "The -p flag can be used to specify a package file:" 1 'dontClear'
      notifyUser "${CLEARCOLOR}${HIGHLIGHTCOLOR3}${SCRIPTNAME} -p /path/to/file${CLEARCOLOR}" 1 'dontClear'
      notifyUser "Any packages named in the specified file will be included in the final insallation." 1 'dontClear'
      notifyUser "${HELPMSG_CLOSING1}" 1 'dontClear'
      notifyUser "${HELPMSG_CLOSING2}" 1 'dontClear'
}
########################## PROGRAM #######################

clear
initColors
initMessages
# For a great article on getopts, and other approaches to handling bash arguments:
# @see https://wiki.bash-hackers.org/howto/getopts_tutorial
while getopts ":hs" OPTION; do
  case "${OPTION}" in
  h)
      printf "%s" "${BANNER}"
          showHelpMsg
      exit 1
    ;;
  s)
      SSH='openssh'
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




