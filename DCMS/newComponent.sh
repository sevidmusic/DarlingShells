#!/bin/sh

notifyUser() {
    MSG=$(printf "\n\n${1}\n\n");
    printf "\n\n${1}\n\n";
    notify-send "${MSG}";
}

promptUser() {
    notifyUser "${1}";
    PROMPT_MSG=$(printf "\n\$dsh: ");
    printf "\n(To use the Darling Shell: Type input if asked | Press <enter> to submit or continue)\n";
    read -p "${PROMPT_MSG}" USER_INPUT;
}

promptUserAndVerifyInput() {
    while :
    do
        clear;

        promptUser "${1}";

        notifyUser  "You entered \"${USER_INPUT}\"\n\nIs this correct?";

        promptUser "If everything looks ok, enter \"Y\" to continue,\npress any other key to repeat last step.";

        if [ "${USER_INPUT}" = "Y" ]; then
            clear;
            break;
        fi
    done;

}

generateTestTrait() {
    TEST_TRAIT_CODE=$(sed "s/DS_COMPONENT_SUBTYPE/USER_DEFINED_COMPONENT_SUBTYPE/g; s/DS_COMPONENT_NAME/USER_DEFINED_COMPONENT_NAME/g" "/home/sevidmusic/Code/DarlingShells/DCMS/templates/Tests/Unit/interfaces/TestTraits/Component.php");
    promptUserAndVerifyInput "The following code was generated for the Test Trait, please review it to make sure there are not any errors\n\n${TEST_TRAIT_CODE}\n\n"
}

notifyUser "Creating new Darling Cms Component";

while :
do
    # 1. Ask user for Component name
    promptUserAndVerifyInput "Please enter a name for the component";
    # 2. Ask user for Component sub-type (used to determine the namespaces of
    #    the classes and test clases that define and test the component.
    promptUserAndVerifyInput "Please enter the component's sub-type, the sub-type\ndetermines the namespace pattern used to define the namespaces\nof the interface, implementations, test trait, and test classes\nrelated to the component.\n\nExample namespace pattern:\n\\DarlingCms\\\*\\component\\SUB\\TYPE\\COMPONENT_NAME\n\nNote: You must escape backslash characters.\n\nNote: Do not inlcude a preceding backslash in the sub-type.\nWrong: \\\\Foo\\\\Bar\nRight: Foo\\\\Bar\n";
    # 3. Generate Interface
    # 4. Generate Abstraction
    # 5. Generate Class
    # 6. Generate TestTrait
    generateTestTrait;
    # 7. Generate Abstract Test
    # 8. Generate Test
    # 9. Optionally, run phpunit

    break;

done;

notifyUser "\n\n\n------- All done. Thank you for using the Darling Shell -------\n\n\n";

