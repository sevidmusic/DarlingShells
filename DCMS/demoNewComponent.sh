#!/bin/bash
clear
printf "\nThe following is a demonstration of the various ways newComponent.sh can be used define new Components for the Darling Data Management System.\n\n"
sleep 7
clear
printf "\n\nOk, lets begin.\n\n"
sleep 4
/home/sevidmusic/Code/DarlingShells/DCMS/demoUI.sh
clear
printf "\n\nOk, now lets call newComponet.sh with the -f flag,\n\nThe -f flag forces newComponent.sh to make your new Component without prompting you to review the values you set for each flag.\n\nNote: The -f flag requires all flags (-x, -e, -t, -c, and -s) to be set,\n\nFinally, the -f flag must be set last or you will get an error message.\n\n"
sleep 15
/home/sevidmusic/Code/DarlingShells/DCMS/demoForceMake.sh
clear
printf "\n\nFinally,lets extend core.\n\nWARNING: It is always better to define new Components as part of an Extension.\n\nThere is really no reason to define new Components for Core unless you are one of the maintainers of the Darling Data Management System.\n\nIf you really want to define new Components for Core newComponent.sh will let you, but you must accept that there may be unintended consequences.\n\nIf you wish to hack at Core for your own education then happy hacking, breaking your DDMS installation is a great way to learn to use it. : )"
sleep 15
/home/sevidmusic/Code/DarlingShells/DCMS/demoExtendingCore.sh
printf "\n\nThanks for watching the demo. Visit https://github.com/sevidmusic/DarlingCmsRedesign for more info on the development of the DDMS.\n\n"
