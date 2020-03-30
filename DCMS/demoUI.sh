#!/bin/bash
clear
printf "\n Let's call: ./newComponent.sh "
sleep 4
./newComponent.sh &&
clear
printf "\n\nYou can pass the following flags to newComponent.sh:\n\n    -x <arg>\n    The -x flag determines whether the new Component will be defined as part of Core or as part of an Extension.\n    Options: \"Core\" or \"Extension\"\n\n    -e <arg>\n    The -e flag is used to set the name of the Extension the Component is being defined for.\n    The -e flag is only used when the -x flag is set to \"Extension\"\n\n    -t <arg>\n    The -t flag determines which Component template is used to generate the PHP code for the new Component.\n    The template must exist and be defined properly in the \"templates\" directory used by newComponent.sh.\n    If you are not sure where tempaltes are located look at the source code of the copy of newComponent.sh that came with your installation of the DDMS to determine which directory teh templates are expected to be in.\n\n    -c <arg>\n    The-c flag is used to set the new Component's name\n\n    -s <arg>\n    The -s flag is used to set the new Component's sub-type.\n    The sub-type is used to determine the appropriate namespace for the new Component. All Components follow a namespace convention similar to \"core\\interfaces|abstractions|classes\\component\\sub-type\\Component\n    The sub-type essentially allows new Components to be nested under the top level Component namespace.\n\n    -f\n    The -f flag does not accept an arugment, if set it will force newComponent.sh to make the new Component without prompting you to reviewing your new Component.\n    If you set the -f flag then ALL other flags MUST be set too\n\nThese flags are all optional, except when the -f flag is used, and if you prefer a UI you can run newComponent.sh without any flags, or you can spedify a few flags and finish in the UI,\n\n"
sleep 42
clear
printf "\n Ok, to demo some flags lets call: ./newComponent.sh -x \"Extension\" -t \"CoreComponent\" -c \"Bar\" -s \"bazzer\"\n(You will notice newComponent.sh will only ask you for the Extension name since we set flags for everything else)\n\n"
sleep 4
./newComponent.sh -x "Extension" -t "CoreComponent"  -c "Bar" -s "bazzer" &&
clear
