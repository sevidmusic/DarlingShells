#!/bin/bash

clear

# source ~/.bash_functions || printf "Error: .bash_functions file not found"
source ~/.bash_aliases || printf "Error: .bash_aliases file not found"

[[ -z "${1}" ]] && setColor 36 && animatedPrint "Error: For loop to run you must speicfy the number of seconds that should pass before each pywal reload." .03 && printf "\n\n" && animatedPrint "i.e., The number of seconds per loop cycle." .03 && printf "\n\n" && animatedPrint "NOTE: The opening script takes takes about 9 seconds to run," .03 && printf "\n\n" && animatedPrint "      so add about 9 seconds to the number you specify and" .03 && printf "\n\n" && animatedPrint "      that will be the total time each loop will actually take to run." .03 && printf "\n\n" && setColor 0 && exit 0

while :
do
    showLoadingBar "Reloading Color Scheme"
    wal -q -i /home/sevidmusic/Wallpapers
    ~/gitClones/intellijPywal/intellijPywalGen.sh ~/.PhpStorm2019.3/config
    neofetch --off --disable cpu gpu memory icons theme shell resolution packages wm de term uptime kernel
    showLoadingBar "Reload complete. Next reload will begin shortly."
    sleep $1
done

