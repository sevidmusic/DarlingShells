#!/bin/sh
notifyUser() {
    notify-send "${1}";
    printf "${1}\n\n";
}

promptUser() {
    notifyUser "${1}";
    read -p 'Prompt: ' USER_INPUT;
}

askUserForComponentName() {
    while :
    do

        # 1. Ask for Object Name
        promptUser "Please enter a name for the Component";

        notifyUser  "You entered \"${USER_INPUT}\"...is this correct";

        promptUser "Enter \"Y\" to continue, \"N\" to change name...";

        if [ "${USER_INPUT}" = "Y" ]; then
            break;
        fi

    done;

}

notifyUser "Creating new Darling Cms Component";

while :
do

    askUserForComponentName;

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
