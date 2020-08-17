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
  printf "\n"
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
  printf " %s\n" "${CLEARCOLOR}${ATTENTIONEFFECT}${ATTENTIONEFFECTCOLOR}[100%]${CLEARCOLOR}"
  setColor 0
  sleep 1
  if [[ "${2}" != "dontClear" ]]; then
    clear
  fi
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
      animatedPrint "${CLEARCOLOR}${NOTIFYCOLOR}This script will wipe and reformat the specified drive as Ext4 with one partition.${CLEARCOLOR}"
      insertLines
      animatedPrint "${CLEARCOLOR}${NOTIFYCOLOR}The following flags are available:${CLEARCOLOR}"
      insertLines
      animatedPrint "${CLEARCOLOR}${NOTIFYCOLOR}-h Show Help Message${CLEARCOLOR}"
      insertLines
      animatedPrint "${CLEARCOLOR}${NOTIFYCOLOR}-s Show available drives/devices via lsblk${CLEARCOLOR}"
      insertLines
      animatedPrint "${CLEARCOLOR}${NOTIFYCOLOR}-d <arg> Name of the drive/device to wipe and reformat as Ext4${CLEARCOLOR}"
      insertLines
   exit
    ;;
  s)
      animatedPrint "${CLEARCOLOR}${NOTIFYCOLOR}The following devices are available:${CLEARCOLOR}"
      insertLines
      lsblk
      insertLines
    exit
    ;;
  d)
      [[ -z "$(lsblk | grep "${OPTARG}")" ]] && insertLines && animatedPrint "${CLEARCOLOR}${ATTENTIONEFFECT}${WARNINGCOLOR}WARNING: ${CLEARCOLOR}${WARNINGCOLOR}The specified drive/device, ${CLEARCOLOR}${NOTIFYCOLOR}${OPTARG}${CLEARCOLOR}${WARNINGCOLOR}, is not available." && insertLines && animatedPrint "${CLEARCOLOR}${WARNINGCOLOR}The following drives/devices are available${CLEARCOLOR}" && insertLines && lsblk && insertLines && animatedPrint "${CLEARCOLOR}${WARNINGCOLOR}Please make sure the drive/device is available and try again.${CLEARCOLOR}" && insertLines && exit
      insertLines
      animatedPrint "${CLEARCOLOR}${ATTENTIONEFFECT}${WARNINGCOLOR}WARNING${CLEARCOLOR}"
      insertLines
      animatedPrint "${CLEARCOLOR}${NOTIFYCOLOR}You are about to erase and reformat the drive named ${CLEARCOLOR}${WARNINGCOLOR}${OPTARG}${CLEARCOLOR}"
      insertLines
      lsblk | grep "${OPTARG}"
      insertLines
      promptUser "Enter Y to continue, any other key to quit."
      if [[ "${CURRENT_USER_INPUT}" == "Y" ]] || [[ $FORCE_MAKE -eq 1 ]]; then
          insertLines
          showLoadingBar "Preparing to wipe drive ${OPTARG}"
          sudo dd if="/dev/zero" of="/dev/${OPTARG}" bs="4096" status="progress" && insertLines && animatedPrint "${CLEARCOLOR}${NOTIFYCOLOR}Drive wiped successfully{CLEARCOLOR}"
          showLoadingBar "Preparing to format drive ${OPTARG} as Ext4 with one partition"
          showLoadingBar "Creating GPT partition table"
          sudo parted "/dev/${OPTARG}" --script -- mklabel gpt && insertLines && animatedPrint "${CLEARCOLOR}${NOTIFYCOLOR}GPT Partition Table created successfully${CLEARCOLOR}"
          showLoadingBar "Creating Ext4 partition using all available space"
          sudo parted "/dev/${OPTARG}" --script -- mkpart primary ext4 0% 100% && insertLines && animatedPrint "${CLEARCOLOR}${NOTIFYCOLOR}Ext4 Partition created successfully, used all available space${CLEARCOLOR}"
          showLoadingBar "Formatting partition as Ext4"
          sudo mkfs.ext4 -F "/dev/${OPTARG}1" && insertLines && animatedPrint "${CLEARCOLOR}${NOTIFYCOLOR}Partition foramtted as Ext4 successfully${CLEARCOLOR}"
          animatedPrint "${CLEARCOLOR}${NOTIFYCOLOR}Results:${CLEARCOLOR}"
          sudo parted "/dev/${OPTARG}" --script print
          insertLines
          lsblk | grep "${OPTARG}"
          insertLines
          animatedPrint "Finished"
          insertLines
      fi
      ;;
  *)
    printf "\nInvalid flag or invalid use of flag: %s\n\nFor help, use -h\n\n" "${OPTARG}"
    exit
    ;;
  esac
done

