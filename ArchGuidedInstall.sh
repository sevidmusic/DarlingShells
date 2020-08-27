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


initColors

while getopts "h" OPTION; do
  case "${OPTION}" in
  h)
    printf "\n\n%sHelp Message:%s\n\n" "${CLEARCOLOR}${NOTIFYCOLOR}" "${CLEARCOLOR}"
    exit
    ;;
  *)
    printf "\n\n%sInvalid flag %s!\n\nUse -h flag for help\n\n%s -h\n\n%s\n\n" "${CLEARCOLOR}${NOTIFYCOLOR}" "${*}" "${0}"  "${CLEARCOLOR}"
    exit
    ;;
  esac
done
