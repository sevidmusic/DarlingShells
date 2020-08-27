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
    HELPMSG='
 I developed this script as a guide for myself. It walks me through the process of installing Arch linux
 with the configuration and packages I am partial to. Feel free to use it or modify it, just be aware
 that I wrote this for myself, so if you use it you may wish to modify it to suit your needs, or to
 accomodate changes to the Arch installation process in the event that I stop maintaing this script.'

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
      printf "\n%s\n" $_charCount
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
  if [[ $FORCE_MAKE -ne 1 ]] && [[ "${2}" != "dontClear" ]]; then
    clear
  fi
}

initColors
initMessages

while getopts "h" OPTION; do
  case "${OPTION}" in
  h)
      printf "%s" "${BANNER}"
      animatedPrint "${HELPMSG}"
    exit
    ;;
  *)
    printf "\n\n%sInvalid flag %s!\n\nUse -h flag for help\n\n%s -h\n\n%s\n\n" "${CLEARCOLOR}${NOTIFYCOLOR}" "${*}" "${0}"  "${CLEARCOLOR}"
    exit
    ;;
  esac
done
