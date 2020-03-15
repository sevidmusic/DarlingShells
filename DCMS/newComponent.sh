#!/bin/bash

# OPTIONS=("Foo" "Bar" "Baz");
# RESPONSES=('Bar-Bazzer-Foo' 'Foo-Bazzer-Bar' 'Bazzer-Bar-Foo');
# askUserForSelection $OPTIONS $RESPONSES;

askUserForSelection() {
  local -n _aufs_options=$2
  local -n _aufs_responses=$3
  local RESPONSE_INDEX
  local RESPONSE
  PS3=$(printf "%s\n%s" "${1}" "${DSHCOLOR}\$dsh: ${USRPRMPTCOLOR}")
  select opt in "${_aufs_options[@]}"; do
    case $opt in
    ${_aufs_options[$(("${REPLY}" - 1))]})
      if [[ -n "${opt}" ]]; then
        RESPONSE_INDEX=$(("${REPLY}" - 1))
        RESPONSE=$(echo "${_aufs_responses[${RESPONSE_INDEX}]}" | sed -E "s,-, ,g;")
        promptUserAndNotify "${RESPONSE}"
        PREVIOUS_USER_INPUT="${opt}"
        break
      fi
      echo "${CLEARCOLOR}${HIGHLIGHTCOLOR2}${REPLY}${CLEARCOLOR}${WARNINGCOLOR} is not a valid option, please enter the number that corresponds to your selection.${CLEARCOLOR}"
      ;;
    esac
  done
}

initVars() {
  local _iv_options
  local _iv_responses
  WARNINGCOLOR=$(setColor 35)
  CLEARCOLOR=$(setColor 0)
  NOTIFYCOLOR=$(setColor 33)
  DSHCOLOR=$(setColor 41)
  USRPRMPTCOLOR=$(setColor 41)
  PHPCODECOLOR=$(setColor 42)
  HIGHLIGHTCOLOR=$(setColor 41)
  HIGHLIGHTCOLOR2=$(setColor 45)
  ATTENTIONEFFECT=$(setColor 5)
  ATTENTIONEFFECTCOLOR=$(setColor 36)
  DARKTEXTCOLOR=$(setColor 30)
  _iv_options=("Core" "Extension")
  _iv_responses=("${CLEARCOLOR}${ATTENTIONEFFECT}${ATTENTIONEFFECTCOLOR}WARNING${CLEARCOLOR}${WARNINGCOLOR}: Defining new Components for core should only be done if absolutely necessary, and you should only do so if you are sure you know what you are doing and understand the consequences! ${DARKTEXTCOLOR}${HIGHLIGHTCOLOR2}It is recommended that you define new Components as part of an Extension. Modifying Core can break Core!${CLEARCOLOR}${WARNINGCOLOR} Are you sure you want to proceed? (Type \"${CLEARCOLOR}${HIGHLIGHTCOLOR}Y${CLEARCOLOR}${WARNINGCOLOR}\" and press \"${CLEARCOLOR}${HIGHLIGHTCOLOR}<enter>${CLEARCOLOR}${WARNINGCOLOR}\" to continue, press \"${CLEARCOLOR}${HIGHLIGHTCOLOR}<ctrl> c${CLEARCOLOR}${WARNINGCOLOR}\" to quit and start over.${CLEARCOLOR}" "You have chosen to create a new Component for an Extension, if this is not correct press <ctrl> c to quit, otherwise type Y and press <enter>")
  askUserForSelection "${NOTIFYCOLOR}Is this Component being defined as part of ${CLEARCOLOR}${HIGHLIGHTCOLOR}Core${CLEARCOLOR}${NOTIFYCOLOR} or as part of an ${CLEARCOLOR}${HIGHLIGHTCOLOR}Extension${NOTIFYCOLOR}${CLEARCOLOR}${NOTIFYCOLOR}?${CLEARCOLOR}" _iv_options _iv_responses
  COMPONENT_EXTENDS="${PREVIOUS_USER_INPUT}"
  if [[ "${COMPONENT_EXTENDS}" == "Core" ]]; then
    EXTENSION_NAME=""
    COMPONENT_TEST_TRAIT_TARGET_ROOT_DIR="./Tests/Unit/interfaces/component"
    COMPONENT_ABSTRACT_TEST_TARGET_ROOT_DIR="./Tests/Unit/abstractions/component"
    COMPONENT_TEST_TARGET_ROOT_DIR="./Tests/Unit/classes/component"
    COMPONENT_INTERFACE_TARGET_ROOT_DIR="./core/interfaces/component"
    COMPONENT_ABSTRACTION_TARGET_ROOT_DIR="./core/abstractions/component"
    COMPONENT_CLASS_TARGET_ROOT_DIR="./core/classes/component"
  fi

  if [[ "${PREVIOUS_USER_INPUT}" == "Extension" ]]; then
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
  printf "\e[%sm" "${1}"
}

writeWordSleep() {
  printf "%s" "${1}"
  sleep "${2}"
}

sleepWriteWord() {
  sleep "${2}"
  printf "%s" "${1}"
}

sleepWriteWordSleep() {
  sleep "${2}"
  printf "%s" "${1}"
  sleep "${2}"
}

showLoadingBar() {
  sleepWriteWordSleep "${1}" .3
  setColor 43
  INC=0
  while [[ ${INC} -le 42 ]]; do
    sleepWriteWordSleep ":" .009
    INC=$((INC + 1))
  done
  echo "[100%]"
  setColor 0
  sleep 0.42
  clear
}

notifyUser() {
  printf "\n%s%s%s\n" "${NOTIFYCOLOR}" "${1}" "${CLEARCOLOR}"
}

promptUser() {
  notifyUser "${1}"
  PROMPT_MSG=$(printf "%s\n%s\$dsh: %s" "${CLEARCOLOR}" "${DSHCOLOR}" "${USRPRMPTCOLOR}")
  PREVIOUS_USER_INPUT="${CURRENT_USER_INPUT}"
  read -p "${PROMPT_MSG}" CURRENT_USER_INPUT
  setColor 0
}

promptUserAndVerifyInput() {
  while :; do
    clear
    promptUser "${1}"
    clear
    notifyUser "You entered \"${CLEARCOLOR}${HIGHLIGHTCOLOR}${CURRENT_USER_INPUT}${CLEARCOLOR}${NOTIFYCOLOR}\"Is this correct?${CLEARCOLOR}"
    if [[ "${CURRENT_USER_INPUT}" == "Y" ]]; then
      clear
      break
    fi
    promptUser "If so, type ${CLEARCOLOR}${HIGHLIGHTCOLOR}\"Y\"${CLEARCOLOR}${NOTIFYCOLOR} and press ${CLEARCOLOR}${HIGHLIGHTCOLOR}<enter>${CLEARCOLOR}${NOTIFYCOLOR} to continue to next step, or just press ${CLEARCOLOR}${HIGHLIGHTCOLOR}<enter>${CLEARCOLOR}${NOTIFYCOLOR} to repeat the last step.${CLEARCOLOR}"
    if [[ "${CURRENT_USER_INPUT}" == "Y" ]]; then
      clear
      break
    fi
  done
}

promptUserAndNotify() {
  setColor 0
  while :; do
    clear
    promptUser "${1}"
    clear
    if [[ "${CURRENT_USER_INPUT}" == "Y" ]]; then
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
  if [[ "${FILE_NAME_SUFFIX}" == "TestTrait" ]]; then
    GENERATED_FILE_PATH=$(echo "${GENERATED_FILE_ROOT_DIR_PATH}/${USER_DEFINED_COMPONENT_SUBTYPE}/TestTraits/${USER_DEFINED_COMPONENT_NAME}${FILE_NAME_SUFFIX}.php" | sed -E "s,\\\,/,g; s,//,/,g;")
  fi
  PHP_CODE=$(sed -E "s/DS_EXTENSION_NAME/${EXTENSION_NAME}/g; s/DS_PARENT_COMPONENT_SUBTYPE/${USER_DEFINED_PARENT_COMPONENT_SUBTYPE}/g; s/DS_PARENT_COMPONENT_NAME/${USER_DEFINED_PARENT_COMPONENT_NAME}/g; s/DS_COMPONENT_SUBTYPE/${USER_DEFINED_COMPONENT_SUBTYPE}/g; s/DS_COMPONENT_NAME/${USER_DEFINED_COMPONENT_NAME}/g; s/[$][A-Z]/\L&/g; s/->[A-Z]/\L&/g; s/\\\\\\\/\\\/g; s/\\\;/;/g;" "${1}")
  GENERATED_FILE_SUB_DIR_PATH=$(echo "${GENERATED_FILE_PATH}" | sed -E "s/\/${USER_DEFINED_COMPONENT_NAME}${FILE_NAME_SUFFIX}.php//g")
  printf "%s\n\n%sThe following code was generated using the %s%s%s%s%s template, please review it to make sure there are not any errors:%s\n\n" "${CLEARCOLOR}" "${NOTIFYCOLOR}" "${CLEARCOLOR}" "${HIGHLIGHTCOLOR}" "${TEMPLATE}" "${CLEARCOLOR}" "${NOTIFYCOLOR}" "${CLEARCOLOR}"
  echo "${PHPCODECOLOR}${PHP_CODE}"
  promptUser "If everything looks ok press <enter>"
  showLoadingBar "Writing file ${GENERATED_FILE_PATH} "
  mkdir -p "${GENERATED_FILE_SUB_DIR_PATH}"
  echo "${PHP_CODE}" >"${GENERATED_FILE_PATH}"
}

askUserForComponentName() {
  promptUserAndVerifyInput "Please enter a name for the component"
  USER_DEFINED_COMPONENT_NAME="${PREVIOUS_USER_INPUT}"
}

askUserForComponentSubtype() {
  promptUserAndVerifyInput "Please enter the component's sub-type, the sub-type determines the namespace pattern used to define the namespaces of the interface, implementations, test trait, and test classes related to the component. Example namespace pattern: \\DarlingCms\\\*\\component\\SUB\\TYPE\\${USER_DEFINED_COMPONENT_NAME} Note: You must escape backslash characters. Note: Do not include a preceding backslash in the sub-type. Wrong: \\\\Foo\\\\Bar Right: Foo\\\\Bar"
  #USER_DEFINED_COMPONENT_SUBTYPE=$(echo "${PREVIOUS_USER_INPUT}" | sed 's,\\,\\\\,g')
  USER_DEFINED_COMPONENT_SUBTYPE=${PREVIOUS_USER_INPUT/\\/\\\\}
}

askUserForParentComponentName() {
  promptUserAndVerifyInput "Please enter the name of the component this component extends:"
  USER_DEFINED_PARENT_COMPONENT_NAME="${PREVIOUS_USER_INPUT}"
}

askUserForParentComponentSubtype() {
  promptUserAndVerifyInput "Please enter the subtype of the component this component extends:"
  #USER_DEFINED_PARENT_COMPONENT_SUBTYPE=$(echo "${PREVIOUS_USER_INPUT}" | sed 's,\\,\\\\,g')
  USER_DEFINED_PARENT_COMPONENT_SUBTYPE=${PREVIOUS_USER_INPUT/\\/\\\\}
}

showWelcomeMessage() {
  clear
  printf "\n"
  setColor 32
  sleepWriteWordSleep "W" .03
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
  sleepWriteWordSleep "o" .03
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
  sleepWriteWordSleep "l" .03
  setColor 36
  printf "\n"
  printf "\n"
  showLoadingBar "Loading New Component Module"
}

askUserForTemplateDirectoryName() {
  local _auftdn_options
  local _auftdn_responses
  _auftdn_options=("Component" "OutputComponent" "SwitchableComponent")
  _auftdn_responses=('You selected the Component template, is this correct?' 'You selected the OutputComponent template, is that correct?' 'You selected the SwitchableComponent template, is that correct?')
  askUserForSelection "Please select the template that should be used to generate the php files." _auftdn_options _auftdn_responses
  TEMPLATE="${PREVIOUS_USER_INPUT}"
  TEST_TRAIT_TEMPLATE_FILE_PATH="./templates/${TEMPLATE}/TestTrait.php"
  ABSTRACT_TEST_TEMPLATE_FILE_PATH="./templates/${TEMPLATE}/AbstractTest.php"
  TEST_TEMPLATE_FILE_PATH="./templates/${TEMPLATE}/Test.php"
  INTERFACE_TEMPLATE_FILE_PATH="./templates/${TEMPLATE}/Interface.php"
  ABSTRACTION_TEMPLATE_FILE_PATH="./templates/${TEMPLATE}/Abstraction.php"
  CLASS_TEMPLATE_FILE_PATH="./templates/${TEMPLATE}/Class.php"
}

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
