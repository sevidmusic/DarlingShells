#!/bin/sh

TEMPLATE_FILE_PATH="/home/sevidmusic/Code/DarlingShells/DCMS/templates/Tests/Unit/interfaces/TestTraits/Component.php";

notifyUser() {
    MSG=$(printf "\n${1}\n");
    printf "\n${1}\n";
    notify-send "${MSG}";
}

promptUser() {
    notifyUser "${1}";
    PROMPT_MSG=$(printf "\n\$dsh: ");
    PREVIOUS_USER_INPUT="${USER_INPUT}";
    read -p "${PROMPT_MSG}" USER_INPUT;
}

promptUserAndVerifyInput() {
    while :
    do
        clear;

        promptUser "${1}";

        clear;

        notifyUser  "You entered \"${USER_INPUT}\"\n\nIs this correct?";

        if [ "${USER_INPUT}" = "Y" ]; then
            clear;
            break;
        fi

        promptUser "If so, type \"Y\" and press <enter> to continue,\npress <enter> repeat last step.";

        if [ "${USER_INPUT}" = "Y" ]; then
            clear;
            break;
        fi
    done;

}

promptUserAndNotify() {
    while :
    do
        clear;

        promptUser "${1}";

        clear;

        if [ "${USER_INPUT}" = "Y" ]; then
            clear;
            break;
        fi

    done;

}

generatePHPCodeFromTemplate() {
    PHP_CODE=$(sed -E "s/DS_COMPONENT_SUBTYPE/${USER_DEFINED_COMPONENT_SUBTYPE}/g; s/DS_COMPONENT_NAME/${USER_DEFINED_COMPONENT_NAME}/g; s/[\$_][A-Z]/\L&/g; s/->[A-Z]/\L&/g" "${1}");
    promptUserAndNotify "The following code was generated, please review it to make sure there are not any errors\n\n${PHP_CODE}\n\nIf everything looks ok type \"Y\" and press <enter>"
    printf "${PHP_CODE}" > ./TEMP_GEN_FILE.php;
}

askUserForComponentName() {
    promptUserAndVerifyInput "Please enter a name for the component";
    USER_DEFINED_COMPONENT_NAME="${PREVIOUS_USER_INPUT}";
}

askUserForComponentSubtype() {
    promptUserAndVerifyInput "Please enter the component's sub-type, the sub-type\ndetermines the namespace pattern used to define the namespaces\nof the interface, implementations, test trait, and test classes\nrelated to the component.\n\nExample namespace pattern:\n\\DarlingCms\\\*\\component\\SUB\\TYPE\\${USER_DEFINED_COMPONENT_NAME}\n\nNote: You must escape backslash characters.\n\nNote: Do not inlcude a preceding backslash in the sub-type.\nWrong: \\\\Foo\\\\Bar\nRight: Foo\\\\Bar\n";
    USER_DEFINED_COMPONENT_SUBTYPE=$(echo "${PREVIOUS_USER_INPUT}" | sed 's,\\,\\\\,g');
}

while :
do
    # 0. SHOW WELCOME MESSAGE
    askUserForComponentName;
    askUserForComponentSubtype;
    #    the classes and test clases that define and test the component.
    # 3. Generate Interface
    # 4. Generate Abstraction
    # 5. Generate Class
    generatePHPCodeFromTemplate "${TEMPLATE_FILE_PATH}";
    # 7. Generate Abstract Test
    # 8. Generate Test
    # 9. Optionally, run phpunit

    break;

done;

notifyUser "\n\n\n------- All done. Thank you for using the Darling Shell -------\n\n\n";

