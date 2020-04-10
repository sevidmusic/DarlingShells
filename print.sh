#!/bin/bash
read input

text=$( echo "${input}" | sed -E "s/ /_/g;")
speed=$1

animatedPrint()
{
  local _text, _speed
  _text="${1}"
  _speed="${2}"
  printf "\n\nText:%s\n\nSpeed:%s\n\n" "${_text}" $_speed
  for (( i=0; i< ${#_text}; i++ )); do
      printf "%s" ${_text:$i:1}
      sleep $_speed
  done
}

animatedPrint "${text}" $speed
