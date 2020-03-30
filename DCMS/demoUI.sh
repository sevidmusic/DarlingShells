#!/bin/bash
clear
printf "\n\n Let's call: ./newComponent.sh "
sleep 4

./newComponent.sh

clear
printf "\n\nLet's review the flags that can be passed to newComponent.sh:\n\n\n\n"
sleep 3

clear
printf "\n\n    ./newComponent -x <arg>\n\n    The -x flag determines whether the new Component will be defined as part of Core or as part of an Extension.\n\n    Options: \"Core\" or \"Extension\""
sleep 10

clear
printf "\n\n    ./newComponent -e <arg>\n\n    The -e flag is used to set the name of the Extension the Component is being defined for.\n\n    The -e flag is only used when the -x flag is set to \"Extension\""
sleep 10

clear
printf "\n\n    ./newComponent -t <arg>\n\n    The -t flag determines which Component template is used to generate the PHP code for the new Component.\n\n    The template must exist and be defined properly in the \"templates\" directory used by newComponent.sh.\n\n    If you are not sure where tempaltes are located look at the source code of the copy of newComponent.sh that\n    came with your installation of the DDMS to determine which directory teh templates are expected to be in."
sleep 10

clear
printf "\n\n    ./newComponent -c <arg>\n\n    The-c flag is used to set the new Component's name"
sleep 4

clear
printf "\n\n    ./newComponent -s <arg>\n\n    The -s flag is used to set the new Component's sub-type.\n\n    The sub-type is used to determine the appropriate namespace for the new Component.\n\n    All Components follow a namespace convention similar to:\n    \"core\\interfaces|abstractions|classes\\component\\sub-type\\Component\n\n    The sub-type essentially allows new Components to be nested under the top level Component namespace."
sleep 10

clear
printf "\n\n    ./newComponent ... -f\n\n    The -f flag does not accept an arugment, if set it will force newComponent.sh to make\n    the new Component without prompting you to reviewing your new Component.\n\n    If you set the -f flag then ALL other flags MUST be set too"
sleep 10

clear
printf "\n\nThese flags are all optional, except when the -f flag is used, and if you prefer a UI you can run newComponent.sh without any flags, or you can spedify a few flags and finish in the UI,\n\n\n\n"
sleep 10

clear
printf "\n\n Ok, to demo some flags lets call: ./newComponent.sh -x \"Extension\" -t \"CoreComponent\" -c \"Bar\" -s \"bazzer\"\n\n(You will notice newComponent.sh will only ask you for the Component's name since we set flags for everything else)\n\n\n\n"
sleep 4

./newComponent.sh -x "Extension" -t "CoreComponent" -c "Bar" -s "bazzer"

clear
