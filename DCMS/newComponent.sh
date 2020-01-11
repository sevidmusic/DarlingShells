#!/bin/sh
notifyUser() {
    notify-send "${1}";
    printf "${1}\n\n";
}

promptUser() {
    notifyUser "${1}";
    read -p 'Prompt: ' USER_INPUT;
}

notifyUser "Creating new Darling Cms Component";

while :
do

    while :
    do

        # 1. Ask for Object Name
        promptUser "Please enter a name for the Component";

#        read -p 'Pleae enter a name for the Component' COMPONENT_NAME;

        printf "You entered \"${USER_INPUT}\"...is this correct";

        read -p "Enter \"Y\" to continue, \"N\" to change name..." NAME_IS_CORRECT;

        if [ "${NAME_IS_CORRECT}" = "Y" ]; then
            break;
        fi

    done;
    # 2. Ask for object namespace

    # 3. Generate Interface

    # 4. Generate Abstraction

    # 5. Generate Class

    # 6. Generate TestTrait

    # 7. Generate Abstract Test

    # 8. Generate Test

    # 9. Optionally, run phpunit

    break;

done;

notify-send "Done...";
printf "Done...";
