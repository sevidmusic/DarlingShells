#!/bin/bash


source ~/.bash_functions || printf "Error: .bash_functions file not found"

[[ -z "${1}" ]] && printf "\nYou must speicfy the number of seconds that should pass before each pywal reload, i.e., number of seconds per loop cycle, note each loop may take a bit longer than number of seconds specified.\n" && exit

while :
do
    notify-send "Reloading Color Scheme"
    showLoadingBar "Reloading Color Scheme"
    wal -q -i /home/sevidmusic/Wallpapers
    ~/gitClones/intellijPywal/intellijPywalGen.sh ~/.PhpStorm2019.3/config
    notify-send "Reload complete. Next reload in ${1} seconds"
    showLoadingBar "Reload complete. Next reload in ${1} seconds"
    sleep $1
done

