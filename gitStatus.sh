
#!/bin/bash

setColor() {
    printf "\e[%sm" "${1}"
}

GIT_DIFF=$(git diff --stat)
NO_CHANGE_COLOR=$(setColor 33)
CHANGE_COLOR=$(setColor 42)
CLEAR_COLOR=$(setColor 0)


[[ -z "${GIT_DIFF}" ]] && printf "%s%s%s" "${CHANGE_COLOR}" "No changes..."  "${CLEAR_COLOR}"
[[ -n "${GIT_DIFF}" ]] && printf "%s%s%s" "${CHANGE_COLOR}" "${GIT_DIFF}"  "${CLEAR_COLOR}"

sleep 60
clear
