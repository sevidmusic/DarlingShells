#!/bin/bash


TEST_TRAIT_TEMPLATE_FILE_PATH="/home/sevidmusic/Code/DarlingShells/DCMS/templates/TestTraitTemplate.php";
ABSTRACT_TEST_TEMPLATE_FILE_PATH="/home/sevidmusic/Code/DarlingShells/DCMS/templates/AbstractTest.php";
TEST_TEMPLATE_FILE_PATH="/home/sevidmusic/Code/DarlingShells/DCMS/templates/TestTraitTemplate.php";
INTERFACE_TEMPLATE_FILE_PATH="/home/sevidmusic/Code/DarlingShells/DCMS/templates/TestTraitTemplate.php";
ABSTRACTION_TEMPLATE_FILE_PATH="/home/sevidmusic/Code/DarlingShells/DCMS/templates/TestTraitTemplate.php";
CLASS_TEMPLATE_FILE_PATH="/home/sevidmusic/Code/DarlingShells/DCMS/templates/TestTraitTemplate.php";

writeWordSleep() {
    printf "${1}";
    sleep "${2}";
}

sleepWriteWord() {
    sleep "${2}";
    printf "${1}";
}

sleepWriteWordSleep() {
    sleep "${2}";
    printf "${1}";
    sleep "${2}";
}

showLoadingBar() {
    sleepWriteWordSleep "${1}" .3;
    INC=0;
    while [ $INC -le 23 ]
    do
        sleepWriteWordSleep "." .03;
        INC=$(($INC + 1));
    done;
    clear;
}

notifyUser() {
    MSG=$(printf "\n${1}\n");
    printf "\n${1}\n";
#    notify-send "${MSG}";
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
            showLoadingBar "${2}";
            clear;
            break;
        fi

    done;

}

generatePHPCodeFromTemplate() {
    PHP_CODE=$(sed -E "s/DS_COMPONENT_SUBTYPE/${USER_DEFINED_COMPONENT_SUBTYPE}/g; s/DS_COMPONENT_NAME/${USER_DEFINED_COMPONENT_NAME}/g; s/[$][A-Z]/\L&/g; s/->[A-Z]/\L&/g" "${1}");
    printf "The following code was generated using the ${1} template, please review it to make sure there are not any errors\n\n";
    echo "${PHP_CODE}";
    promptUser "\n\nIf everything looks ok press <enter>";
    showLoadingBar "Writing file";
    echo "${PHP_CODE}" > ./REAL_GEN_FILE.php;
}

askUserForComponentName() {
    promptUserAndVerifyInput "Please enter a name for the component";
    USER_DEFINED_COMPONENT_NAME="${PREVIOUS_USER_INPUT}";
}

askUserForComponentSubtype() {
    promptUserAndVerifyInput "Please enter the component's sub-type, the sub-type\ndetermines the namespace pattern used to define the namespaces\nof the interface, implementations, test trait, and test classes\nrelated to the component.\n\nExample namespace pattern:\n\\DarlingCms\\\*\\component\\SUB\\TYPE\\${USER_DEFINED_COMPONENT_NAME}\n\nNote: You must escape backslash characters.\n\nNote: Do not inlcude a preceding backslash in the sub-type.\nWrong: \\\\Foo\\\\Bar\nRight: Foo\\\\Bar\n";
    USER_DEFINED_COMPONENT_SUBTYPE=$(echo "${PREVIOUS_USER_INPUT}" | sed 's,\\,\\\\,g');
}

showWelcomeMessage() {
    clear;
    sleepWriteWordSleep "\nW" .03;
    sleepWriteWordSleep "e" .03;
    sleepWriteWordSleep "l" .03;
    sleepWriteWordSleep "c" .03;
    sleepWriteWordSleep "o" .03;
    sleepWriteWordSleep "m" .03;
    sleepWriteWordSleep "e" .03;
    sleepWriteWordSleep " " .03;
    sleepWriteWordSleep "t" .03;
    sleepWriteWordSleep "h" .03;
    sleepWriteWordSleep "e" .03;
    sleepWriteWordSleep " " .03;
    sleepWriteWordSleep "D" .03;
    sleepWriteWordSleep "a" .03;
    sleepWriteWordSleep "r" .03;
    sleepWriteWordSleep "l" .03;
    sleepWriteWordSleep "i" .03;
    sleepWriteWordSleep "n" .03;
    sleepWriteWordSleep "g" .03;
    sleepWriteWordSleep " " .03;
    sleepWriteWordSleep "S" .03;
    sleepWriteWordSleep "h" .03;
    sleepWriteWordSleep "e" .03;
    sleepWriteWordSleep "l" .03;
    sleepWriteWordSleep "l\n" .03;
    showLoadingBar "Loading New Component Module";
}

while :
do
    showWelcomeMessage;
    askUserForComponentName;
    askUserForComponentSubtype;
    generatePHPCodeFromTemplate "${TEST_TRAIT_TEMPLATE_FILE_PATH}";
#    generatePHPCodeFromTemplate "${ABSTRACT_TEST_TEMPLATE_FILE_PATH}";
#    generatePHPCodeFromTemplate "${TEST_TEMPLATE_FILE_PATH}";
#    generatePHPCodeFromTemplate "${INTERFACE_TEMPLATE_FILE_PATH}";
#    generatePHPCodeFromTemplate "${ABSTRACTION_TEMPLATE_FILE_PATH}";
#    generatePHPCodeFromTemplate "${CLASS_TEMPLATE_FILE_PATH}";
    break;

done;


