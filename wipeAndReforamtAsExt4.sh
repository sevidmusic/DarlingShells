#!/bin/bash

set -o posix

setColor() {
  printf "\e[%sm" "${1}"
}

insertLines()
{
    printf "\n\n"
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
  local _charsToAnimate _speed _currentChar
  # For some reason spacd get mangled using ${VAR:POS:LIMIT}. so replace spaces with _ here,
  # then add spaces back when needed.
  _charsToAnimate=$( printf "%s" "${1}" | sed -E "s/ /_/g;")
  _speed="${2:-.05}"
  for (( i=0; i< ${#_charsToAnimate}; i++ )); do
      # Replace placeholder _ with space | i.e., fix spaces that were replaced
      _currentChar=$(printf "%s" "${_charsToAnimate:$i:1}" | sed -E "s/_/ /g;")
      printf "%s" "${_currentChar}"
      sleep $_speed
  done
}

showLoadingBar() {
  local _slb_inc _slb_windowWidth _slb_numChars _slb_adjustedNumChars _slb_loadingBarLimit
  insertLines
  animatedPrint "${1}" .05
  setColor 43
  _slb_inc=0
  _slb_windowWidth=$(tput cols)
  _slb_numChars="${#1}"
  _slb_adjustedNumChars=$((_slb_windowWidth - _slb_numChars))
  _slb_loadingBarLimit=$((_slb_adjustedNumChars - 10))
  while [[ ${_slb_inc} -le "${_slb_loadingBarLimit}" ]]; do
    animatedPrint ":" .009
    _slb_inc=$((_slb_inc + 1))
  done
  [[ "${2}" != "dontClear" ]] && clear | printf " %s\n" "${CLEARCOLOR}${ATTENTIONEFFECT}${ATTENTIONEFFECTCOLOR}[100%]${CLEARCOLOR}" && sleep 1
  setColor 0
}

notifyUser() {
  [[ "${2}" == "showInfo" ]] && showInfoPanel
  printf "\n%s%s%s\n" "${NOTIFYCOLOR}" "${1}" "${CLEARCOLOR}"
}

promptUser() {
  local _pu_promptMessage
  notifyUser "${1}" "${2}"
  _pu_promptMessage=$(printf "%s\n%s\$dsh: %s" "${CLEARCOLOR}" "${DSHCOLOR}${DARKTEXTCOLOR}" "${USRPRMPTCOLOR}")
  PREVIOUS_USER_INPUT="${CURRENT_USER_INPUT}"
  read -p "${_pu_promptMessage}" CURRENT_USER_INPUT
  setColor 0
}

promptUserAndVerifyInput() {
  while :; do
    promptUser "${1}" "${2}"
    notifyUser "You entered \"${CLEARCOLOR}${HIGHLIGHTCOLOR}${DARKTEXTCOLOR}${CURRENT_USER_INPUT}${CLEARCOLOR}${NOTIFYCOLOR}\"Is this correct?${CLEARCOLOR}" ""
    promptUser "If so, type ${CLEARCOLOR}${HIGHLIGHTCOLOR}${DARKTEXTCOLOR}\"Y\"${CLEARCOLOR}${NOTIFYCOLOR} and press ${CLEARCOLOR}${HIGHLIGHTCOLOR}${DARKTEXTCOLOR}<enter>${CLEARCOLOR}${NOTIFYCOLOR} to continue to next step, or just press ${CLEARCOLOR}${HIGHLIGHTCOLOR}${DARKTEXTCOLOR}<enter>${CLEARCOLOR}${NOTIFYCOLOR} to repeat the last step.${CLEARCOLOR}"
    if [[ "${CURRENT_USER_INPUT}" == "Y" ]]; then
      showLoadingBar "Thank you, one moment please"
      break
    fi
  done
}

promptUserAndNotify() {
  setColor 0
  while :; do
    promptUser "${1}"
    if [[ "${CURRENT_USER_INPUT}" == "Y" ]]; then
      showLoadingBar "${2}"
      break
    fi
  done
}


clear

initColors

[[ -z "$(which parted)" ]] && insertLines && animatedPrint "${CLEARCOLOR}${ATTENTIONEFFECT}${ATTENTIONEFFECTCOLOR}GNU Parted is required for this script to work.${CLEARCOLOR}" && insertLine && animatedPrint "Please install parted via your distribution's package manager" && insertLine && animatedPrint "Example on Debian based:" && insertLine && animatedPrint "sudo apt install parted" && insertLine && exit 1

while getopts "hsd:" OPTION; do
  case "${OPTION}" in
  h)
      insertLines
      animatedPrint "This script will wipe and reformat the specified drive as Ext4 with one partition."
      insertLines
      animatedPrint "The following flags are available:"
      insertLines
      animatedPrint "${CLEARCOLOR}${NOTIFYCOLOR}-h Show Help Message${CLEARCOLOR}"
      insertLines
      animatedPrint "${CLEARCOLOR}${NOTIFYCOLOR}-s Show available devices via lsblk${CLEARCOLOR}"
      insertLines
    exit
    ;;
  s)
      animatedPrint "The following devices are available:"
      insertLines
      lsblk
      insertLines
    exit
    ;;
  d)
      insertLines
      animatedPrint "${CLEARCOLOR}${ATTENTIONEFFECT}${WARNINGCOLOR}WARNING${CLEARCOLOR}"
      insertLines
      animatedPrint "${CLEARCOLOR}${NOTIFYCOLOR}You are about to erase and reformat the drive named ${CLEARCOLOR}${WARNINGCOLOR}${OPTARG}${CLEARCOLOR}${NOTIFYCOLOR}"
      insertLines
      promptUser "Enter Y to continue, any other key to quit."
      if [[ "${CURRENT_USER_INPUT}" == "Y" ]] || [[ $FORCE_MAKE -eq 1 ]]; then
          showLoadingBar
      fi
      ;;
  *)
    printf "\nInvalid flag or invalid use of flag: %s\n\nFor help, use -h\n\n" "${OPTION}"
    exit
    ;;
  esac
done

