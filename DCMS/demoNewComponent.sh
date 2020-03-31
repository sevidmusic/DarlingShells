#!/bin/bash
clear
printf "\nThe following is a demonstration of the various ways newComponent.sh can be used define new Components for the Darling Data Management System.\n\nVisit https://github.com/sevidmusic/DarlingCmsRedesign for more info on the development of the Darling Data Managemnt System (D.D.M.S.), which is currently being developed as the Darling Cms Experimental Re-Design.\n\n"
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
clear
printf "\n\nCool, let's look at some of the Components we just created:\n\n"
sleep 5

clear
ls -AR --group-directories-first  ./Extensions | grep "[/]*[php]" | sed -E "s,component,,g; s,abstractions,abstractions/component,g; s,classes,classes/component,g; s,interfaces,interfaces/component,g; s,Extensions/Foo/Tests/Unit/interfaces/component/:,,g; s,//,/,g;"
sleep 15

clear
printf "\n\nOk, so now that we have created some new Components, let's run phpunit to make sure our new Components pass the tests defined for their parents.\n"
sleep 7

clear
