#!/bin/bash

set -o posix

setColor() {
  printf "\e[%sm" "${1}"
}

initMessages() {
    BANNER='
 _____       _     __         __  ___              __     ____           __         __ __       __   _
 / ___/__ __ (_)___/ /___  ___/ / / _ |  ____ ____ / /    /  _/___   ___ / /_ ___ _ / // /___ _ / /_ (_)___   ___
/ (_ // // // // _  // -_)/ _  / / __ | / __// __// _ \  _/ / / _ \ (_-</ __// _ `// // // _ `// __// // _ \ / _ \
\___/ \_,_//_/ \_,_/ \__/ \_,_/ /_/ |_|/_/   \__//_//_/ /___//_//_//___/\__/ \_,_//_//_/ \_,_/ \__//_/ \___//_//_/

'
    HELPMSG='I developed this script as a guide for myself. It walks me through the process of installing Arch linux with the configuration and packages I am partial to. Feel free to use it or modify it. If you do use it you may want to modify it to suit your needs, or to accomodate changes to the Arch installation process in the event that I stop maintaing this script. -Sevi D'
    LB_PRE_INSTALL_MSG='Preparing fo pre-insallation steps'
    LB_INSTALL_MSG='Installing Arch'
    LB_POST_INSTALL_MSG='Preparing for post-insallation steps'
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

animatedPrint()
{
  local _charsToAnimate _speed _currentChar _charCount
  # For some reason spacd get mangled using ${VAR:POS:LIMIT}. so replace spaces with _ here,
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

installOpenSSH()
{
    # Determine if ssh exists on Arch iso
    which ssh
    # If not get it
#    pacman -S openssh
    # Start ssh
#    systemctl start sshd
}

performPreInsallation() {
    showLoadingBar "${LB_PRE_INSTALL_MSG}"
    [[ -n "${SSH}" ]] && installOpenSSH
}

performInstallation() {
    showLoadingBar "${LB_INSTALL_MSG}" "dontClear"
}

performPostInstallation() {
    showLoadingBar "${LB_POST_INSTALL_MSG}"
}

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

performPreInsallation
performInstallation
performPostInstallation



