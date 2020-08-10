#!/bin/bash
set -o posix

setColor() {
  printf "\e[%sm" "${1}"
}

animatedPrint()
{
  local _charsToAnimate _speed _currentChar
  # For some reason spacd get mangled using ${VAR:POS:LIMIT}. so replace spaces with _ here,
  # then add spaces back when needed.
  _charsToAnimate=$( printf "%s" "${1}" | sed -E "s/ /_/g;")
  _speed="${2}"
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
  if [[ $FORCE_MAKE -ne 1 ]] && [[ "${2}" != "dontClear" ]]; then
    clear
  fi
}

clear

cd /var/www/html # && /var/www/html/vendor/phpunit/phpunit/phpunit -c /var/www/html/php.xml

showLoadingBar "App tests will begin shortly, waiting for phpunit to finish"

for i in {240..1}
do
    printf "%s" "${i}" && sleep 1 && clear
done

showLoadingBar "Running App tests"

clear

[[ -d /var/www/html/.dcmsJsonData ]] && rm -r /var/www/html/.dcmsJsonData

cd /var/www/html/Apps/dcmsDev && /usr/bin/php ./Components.php
cd /var/www/html/Apps/blackballotpowercontest && /usr/bin/php ./Components.php
cd /var/www/html/Apps/WorkingDemo && /usr/bin/php ./Components.php

clear

[[ ! -d /var/www/html/.dcmsJsonData/dcmsdev ]] && printf "\n\nFailed to install dcmsdev components\n\n"
[[ ! -d /var/www/html/.dcmsJsonData/blackballotpowercontestlocal ]] && printf "\n\nFailed to install blackballotpowercontest components\n\n"
[[ ! -d /var/www/html/.dcmsJsonData/1921683310 ]] && printf "\n\nFailed to install Working Demo components\n\n"

sleep 2
clear

/usr/bin/w3m -dump dcms.dev

sleep 3
clear

/usr/bin/w3m -dump blackballotpowercontest.local

sleep 3
clear

/usr/bin/w3m -dump 192.168.33.10

sleep 3
clear
