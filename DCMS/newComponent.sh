#!/bin/bash

# OPTIONS=("Foo" "Bar" "Baz");
# RESPONSES=('Bar-Bazzer-Foo' 'Foo-Bazzer-Bar' 'Bazzer-Bar-Foo');
# askUserForSelection $OPTIONS $RESPONSES;
askUserForSelection() {
  PS3=$(printf "%s\n%s" "${1}" "${DSHCOLOR}\$dsh: ${INPUTCOLOR}")
  OPTIONS=$2
  RESPONSES=$3
  select opt in "${OPTIONS[@]}"; do
    case $opt in
    ${OPTIONS[$(("${REPLY}" - 1))]})
      if [ -n "${opt}" ]; then
        RESPONSE_INDEX=$(("${REPLY}" - 1))
        RESPONSE=$(echo "${RESPONSES[${RESPONSE_INDEX}]}" | sed -E "s,-, ,g;")
        # printf "\nREPLY: ${REPLY}\nOPT: ${opt}\nRESPONSE_INDEX: ${RESPONSE_INDEX}\nRESPONSE: ${RESPONSE}\nPREVIOUS_USER_INPUT: ${PREVIOUS_USER_INPUT}\n"
        promptUserAndNotify "${RESPONSE}"
        PREVIOUS_USER_INPUT="${opt}"
        break
      fi
      echo "${WARNINGCOLOR}${REPLY} is not a valid option, please enter the number that corresponds to your selction."
      ;;
    esac
  done
}

initVars() {
  WARNINGCOLOR=$(setColor 32)
  CLEARCOLOR=$(setColor 0)
  NOTIFYCOLOR=$(setColor 33)
  DSHCOLOR=$(setColor 36)
  USRPRMPTCOLOR=$(setColor 44)
  INPUTCOLOR=$(setColor 34)
  PHPCODECOLOR=$(setColor 35)
  OPTIONS=("Core" "Extension")
  RESPONSES=("${WARNINGCOLOR}WARNING:-Defing-new-Components-for-core-should-only-be-done-if-absolutely-necessary,-and-you-should-only-do-so-if-you-are-sure-you-know-what-you-are-doing-and-understand-the-consequences!\n\nIt-is-recomendd-that-you-define-new-Componets-as-part-of-an-Extension.\n\nIf-you-chose-to-proceed,-you-have-been-warned,-good-luck-with-your-new-component,-know-bad-things-may-happen,-and-if-they-do-it-will-probably-be-your-new-components-fault.-\n\nAre-you-sure-you-want-to-proceed?\n(Type-Y-and-press-<enter>-to-continue,-press-<ctrl>-c-to-quit-and-start-over." "You-have-chosen-to-create-a-new-Component-for-an-Extension,-if-this-is-not-correct-press-<ctrl>-c-to-quit,-otherwise-type-Y-and-press-<enter>\n")
  askUserForSelection "${NOTIFYCOLOR}Is this Component being defined as part of Core or as part of an Extension?" $OPTIONS $RESPONSES
  if [ "${PREVIOUS_USER_INPUT}" == "Core" ]; then
      EXTENSION_NAME=""
      COMPONENT_TEST_TRAIT_TARGET_ROOT_DIR="./Tests/Unit/interfaces/component"
      COMPONENT_ABSTRACT_TEST_TARGET_ROOT_DIR="./Tests/Unit/abstractions/component"
      COMPONENT_TEST_TARGET_ROOT_DIR="./Tests/Unit/classes/component"
      COMPONENT_INTERFACE_TARGET_ROOT_DIR="./core/interfaces/component"
      COMPONENT_ABSTRACTION_TARGET_ROOT_DIR="./core/abstractions/component"
      COMPONENT_CLASS_TARGET_ROOT_DIR="./core/classes/component"
  fi

  if [ "${PREVIOUS_USER_INPUT}" == "Extension" ]; then
      promptUserAndVerifyInput "What is the name of the Extension this Component will belong to?"
      EXTENSION_NAME="${PREVIOUS_USER_INPUT}"
      COMPONENT_TEST_TRAIT_TARGET_ROOT_DIR="./Extensions/${EXTENSION_NAME}/Tests/Unit/interfaces/component"
      COMPONENT_ABSTRACT_TEST_TARGET_ROOT_DIR="./Extensions/${EXTENSION_NAME}/Tests/Unit/abstractions/component"
      COMPONENT_TEST_TARGET_ROOT_DIR="./Extensions/${EXTENSION_NAME}/Tests/Unit/classes/component"
      COMPONENT_INTERFACE_TARGET_ROOT_DIR="./Extensions/${EXTENSION_NAME}/core/interfaces/component"
      COMPONENT_ABSTRACTION_TARGET_ROOT_DIR="./Extensions/${EXTENSION_NAME}/core/abstractions/component"
      COMPONENT_CLASS_TARGET_ROOT_DIR="./Extensions/${EXTENSION_NAME}/core/classes/component"
  fi
}

setColor() {
  COLOR="\e[${1}m"
  printf "${COLOR}"
}

writeWordSleep() {
  printf "${1}"
  sleep "${2}"
}

sleepWriteWord() {
  sleep "${2}"
  printf "${1}"
}

sleepWriteWordSleep() {
  sleep "${2}"
  printf "${1}"
  sleep "${2}"
}

showLoadingBar() {
  sleepWriteWordSleep "${1}" .3
  setColor 44
  INC=0
  while [ $INC -le 42 ]; do
    sleepWriteWordSleep ":" .009
    INC=$(($INC + 1))
  done
  echo "[100%]"
  setColor 0
  sleep 0.42
  clear
}

notifyUser() {
  printf "\n${NOTIFYCOLOR}${1}${CLEARCOLOR}\n"
}

promptUser() {
  notifyUser "${1}"
  PROMPT_MSG=$(printf "\n${DSHCOLOR}\$dsh: ${USRPRMPTCOLOR}")
  PREVIOUS_USER_INPUT="${USER_INPUT}"
  read -p "${PROMPT_MSG}" USER_INPUT
  setColor 0
}

promptUserAndVerifyInput() {
  while :; do
    clear
    promptUser "${1}"
    clear
    notifyUser "You entered \"${INPUTCOLOR}${USER_INPUT}${NOTIFYCOLOR}\"\n\nIs this correct?"
    if [ "${USER_INPUT}" = "Y" ]; then
      clear
      break
    fi
    promptUser "If so, type ${INPUTCOLOR}\"Y\"${NOTIFYCOLOR} and press ${INPUTCOLOR}<enter>${NOTIFYCOLOR} to continue to next step,\nor just press ${INPUTCOLOR}<enter>${NOTIFYCOLOR} to repeat the last step."
    if [ "${USER_INPUT}" = "Y" ]; then
      clear
      break
    fi
  done
}

promptUserAndNotify() {
  while :; do
    clear
    promptUser "${1}"
    clear
    if [ "${USER_INPUT}" = "Y" ]; then
      showLoadingBar "${2}"
      clear
      break
    fi
  done
}

generatePHPCodeFromTemplate() {
  TEMPLATE="${1}"
  GENERATED_FILE_ROOT_DIR_PATH="${2}"
  FILE_NAME_SUFFIX="${3}"
  GENERATED_FILE_PATH=$(echo "${GENERATED_FILE_ROOT_DIR_PATH}/${USER_DEFINED_COMPONENT_SUBTYPE}/${USER_DEFINED_COMPONENT_NAME}${FILE_NAME_SUFFIX}.php" | sed -E "s,\\\,/,g; s,//,/,g;")
  if [ "${FILE_NAME_SUFFIX}" = "TestTrait" ]; then
    GENERATED_FILE_PATH=$(echo "${GENERATED_FILE_ROOT_DIR_PATH}/${USER_DEFINED_COMPONENT_SUBTYPE}/TestTraits/${USER_DEFINED_COMPONENT_NAME}${FILE_NAME_SUFFIX}.php" | sed -E "s,\\\,/,g; s,//,/,g;")
  fi
  PHP_CODE=$(sed -E "s/DS_PARENT_COMPONENT_SUBTYPE/${USER_DEFINED_PARENT_COMPONENT_SUBTYPE}/g; s/DS_PARENT_COMPONENT_NAME/${USER_DEFINED_PARENT_COMPONENT_NAME}/g; s/DS_COMPONENT_SUBTYPE/${USER_DEFINED_COMPONENT_SUBTYPE}/g; s/DS_COMPONENT_NAME/${USER_DEFINED_COMPONENT_NAME}/g; s/[$][A-Z]/\L&/g; s/->[A-Z]/\L&/g; s/\\\\\\\/\\\/g; s/\\\;/;/g;" "${1}")
  GENERATED_FILE_SUB_DIR_PATH=$(echo "${GENERATED_FILE_PATH}" | sed -E "s/\/${USER_DEFINED_COMPONENT_NAME}${FILE_NAME_SUFFIX}.php//g")
  printf "${NOTIFYCOLOR}The following code was generated using the ${INPUTCOLOR}${TEMPLATE}${NOTIFYCOLOR} template, please review it to make sure there are not any errors:${CLEARCOLOR}\n\n"
  echo "${PHPCODECOLOR}${PHP_CODE}"
  promptUser "\n\nIf everything looks ok press <enter>"
  showLoadingBar "Writing file ${GENERATED_FILE_PATH} "
  mkdir -p "${GENERATED_FILE_SUB_DIR_PATH}"
  echo "${PHP_CODE}" >"${GENERATED_FILE_PATH}"
}

askUserForComponentName() {
  promptUserAndVerifyInput "Please enter a name for the component"
  USER_DEFINED_COMPONENT_NAME="${PREVIOUS_USER_INPUT}"
}

askUserForComponentSubtype() {
  promptUserAndVerifyInput "Please enter the component's sub-type, the sub-type\ndetermines the namespace pattern used to define the namespaces\nof the interface, implementations, test trait, and test classes\nrelated to the component.\n\nExample namespace pattern:\n\\DarlingCms\\\*\\component\\SUB\\TYPE\\${USER_DEFINED_COMPONENT_NAME}\n\nNote: You must escape backslash characters.\n\nNote: Do not inlcude a preceding backslash in the sub-type.\nWrong: \\\\Foo\\\\Bar\nRight: Foo\\\\Bar\n"
  USER_DEFINED_COMPONENT_SUBTYPE=$(echo "${PREVIOUS_USER_INPUT}" | sed 's,\\,\\\\,g')
}

askUserForParentComponentName() {
  promptUserAndVerifyInput "Please enter the name of the component this component extends:"
  USER_DEFINED_PARENT_COMPONENT_NAME="${PREVIOUS_USER_INPUT}"
}

askUserForParentComponentSubtype() {
  promptUserAndVerifyInput "Please enter the subtype of the component this component extends:"
  USER_DEFINED_PARENT_COMPONENT_SUBTYPE=$(echo "${PREVIOUS_USER_INPUT}" | sed 's,\\,\\\\,g')
}

showWelcomeMessage() {
  clear
  setColor 32
  sleepWriteWordSleep "\nW" .03
  setColor 34
  sleepWriteWordSleep "e" .03
  setColor 36
  sleepWriteWordSleep "l" .03
  setColor 32
  sleepWriteWordSleep "c" .03
  setColor 34
  sleepWriteWordSleep "o" .03
  setColor 36
  sleepWriteWordSleep "m" .03
  setColor 32
  sleepWriteWordSleep "e" .03
  setColor 34
  sleepWriteWordSleep " " .03
  setColor 36
  sleepWriteWordSleep "t" .03
  setColor 32
  sleepWriteWordSleep "h" .03
  setColor 34
  sleepWriteWordSleep "e" .03
  setColor 36
  sleepWriteWordSleep " " .03
  setColor 32
  sleepWriteWordSleep "D" .03
  setColor 34
  sleepWriteWordSleep "a" .03
  setColor 36
  sleepWriteWordSleep "r" .03
  setColor 32
  sleepWriteWordSleep "l" .03
  setColor 34
  sleepWriteWordSleep "i" .03
  setColor 36
  sleepWriteWordSleep "n" .03
  setColor 32
  sleepWriteWordSleep "g" .03
  setColor 34
  sleepWriteWordSleep " " .03
  setColor 36
  sleepWriteWordSleep "S" .03
  setColor 32
  sleepWriteWordSleep "h" .03
  setColor 34
  sleepWriteWordSleep "e" .03
  setColor 36
  sleepWriteWordSleep "l" .03
  setColor 32
  sleepWriteWordSleep "l\n" .03
  setColor 36
  showLoadingBar "Loading New Component Module"
}

askUserForTemplateDirectoryName() {
  #promptUserAndVerifyInput "Please enter the name of the directory where the appropriate php code templates are located:"
  #TEMPLATE="${PREVIOUS_USER_INPUT}"

  #while [ ! -d "./templates/${TEMPLATE}" ]; do
  #  promptUserAndVerifyInput "The specified template directory does not exist, please enter an existing template directory's name"
  #  TEMPLATE="${PREVIOUS_USER_INPUT}"
  #done

  OPTIONS=("Component" "OutputComponent" "SwitchableComponent");
  RESPONSES=('You-selected-the-Component-template,-is-this-correct?' 'You-selected-the-OutputComponent-template,-is-that-correct?' 'You-selected-the-SwitchableComponent-template,-is-that-correct?');
  askUserForSelection "Please select the template that should be used to generate the php files." $OPTIONS $RESPONSES;
  TEMPLATE="${PREVIOUS_USER_INPUT}"
  TEST_TRAIT_TEMPLATE_FILE_PATH="./templates/${TEMPLATE}/TestTrait.php"
  ABSTRACT_TEST_TEMPLATE_FILE_PATH="./templates/${TEMPLATE}/AbstractTest.php"
  TEST_TEMPLATE_FILE_PATH="./templates/${TEMPLATE}/Test.php"
  INTERFACE_TEMPLATE_FILE_PATH="./templates/${TEMPLATE}/Interface.php"
  ABSTRACTION_TEMPLATE_FILE_PATH="./templates/${TEMPLATE}/Abstraction.php"
  CLASS_TEMPLATE_FILE_PATH="./templates/${TEMPLATE}/Class.php"
}
while :; do
  showWelcomeMessage
  initVars
  askUserForTemplateDirectoryName
  askUserForParentComponentName
  askUserForParentComponentSubtype
  askUserForComponentName
  askUserForComponentSubtype
  generatePHPCodeFromTemplate "${TEST_TRAIT_TEMPLATE_FILE_PATH}" "${COMPONENT_TEST_TRAIT_TARGET_ROOT_DIR}" "TestTrait"
  generatePHPCodeFromTemplate "${ABSTRACT_TEST_TEMPLATE_FILE_PATH}" "${COMPONENT_ABSTRACT_TEST_TARGET_ROOT_DIR}" "Test"
  generatePHPCodeFromTemplate "${TEST_TEMPLATE_FILE_PATH}" "${COMPONENT_TEST_TARGET_ROOT_DIR}" "Test"
  generatePHPCodeFromTemplate "${INTERFACE_TEMPLATE_FILE_PATH}" "${COMPONENT_INTERFACE_TARGET_ROOT_DIR}" ""
  generatePHPCodeFromTemplate "${ABSTRACTION_TEMPLATE_FILE_PATH}" "${COMPONENT_ABSTRACTION_TARGET_ROOT_DIR}" ""
  generatePHPCodeFromTemplate "${CLASS_TEMPLATE_FILE_PATH}" "${COMPONENT_CLASS_TARGET_ROOT_DIR}" ""
  setColor 0
  break

done
