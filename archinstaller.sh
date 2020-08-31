#!/bin/bash

set -o posix

setColor() {
  printf "\e[%sm" "${1}"
}

initColors() {
  WARNINGCOLOR=$(setColor 35)
  CLEARCOLOR=$(setColor 0)
  NOTIFYCOLOR=$(setColor 33)
  DSHCOLOR=$(setColor 41)
  USRPRMPTCOLOR=$(setColor 41)
  HIGHLIGHTCOLOR=$(setColor 41)
  HIGHLIGHTCOLOR2=$(setColor 45)
  ATTENTIONEFFECT=$(setColor 5)
  ATTENTIONEFFECTCOLOR=$(setColor 36)
  DARKTEXTCOLOR=$(setColor 30)
}

initMessages() {
    SCRIPTNAME=`basename "$(realpath $0)"`
    BANNER='

 _                          ___
| \ _.._|o._  _   /\ .__|_   | ._  __|_ _.|| _ ._
|_/(_|| ||| |(_| /--\|(_| | _|_| |_> |_(_|||(/_|
              _|

'
    HELPMSG="I developed ${SCRIPTNAME} as a guide for myself. It walks me through the process of installing Arch linux on a legacy BIOS using ext4 for a filesystem. Pasing the -p flag with a filename like: ${SCRIPTNAME} -p /path/to/file; will tell the installer to include the packages in the specified file in the final insallation. Feel free to modify the script to suit your needs. -Sevi D"
    LB_PRE_INSTALL_MSG='Pre-installation will begin in a moment'
    LB_INSTALL_MSG='Insallation of Arch Linx will begin in a moment'
    LB_POST_INSTALL_MSG='Post-installation will being in a moment'
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
      [[ $_charCount == 80 ]] && _charCount=0 && printf "\n\n "
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

setRootPassword()
{
    printf "\n\n"
    animatedPrint "Please set the root password:"
    printf "\n\n"
    passwd
    printf "\n\n"
    animatedPrint "The password you just set will NOT persist to the actual installation."
    printf "\n\n"
    animatedPrint "If the -s flag was supplied, then the password you just set can be used to login to the installation media as root via ssh."
    sleep 2
    clear
}

startSSH()
{
    if [[ "$(systemctl list-units --type=service | grep ssh | wc -l)" -gt 0 ]]; then
    	printf "\n\n"
            animatedPrint "${SSH} is already running:"
    	printf "\n\n"
            animatedPrint "Location: $(which ssh)"
    	printf "\n\n"
            animatedPrint "Service: $(systemctl list-units --type=service | grep ssh | awk '{ print $1 }')"
    	printf "\n\n"
    	return
    fi
    showLoadingBar "Attempting to start sshd"
    systemctl start sshd || printf "\n\n" && animatedPrint "Failed to start sshd. You may need to install/re-install/configure ${SSH}." && exit 1
    printf "\n\n"
    animatedPrint "ssh is now running, you should now be able to login to the installation media as root from your host machine via ssh."
    printf "\n\n"
    animatedPrint "The password you set in the previous step is the password you will use to login."
    printf "\n\n"
    animatedPrint "The following is your ip info (obtained via ip a). You may need to add the ip to your HOST machine's /etc/hosts file"
    printf "\n\n"
    ip a
    animatedPrint "Once logged in just run this script again WITHOUT the -s flag to continue the installation process"
    printf "\n\n"
    sleep 5
    showLoadingBar "Moving on"
}

installPKGSForInstaller()
{
    showLoadingBar "Installing \"which\" so program locations can be determined"
    pacman -S which --noconfirm
    clear
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
      animatedPrint "${HELPMSG}" 0.042
      printf "\n\n"
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

