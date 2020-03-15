#!/bin/bash

displayColor() {
    printf "\n\e[%smColor: %s\e[0m" "${1}" "${1}"
}

for i in {0..49}
do
    displayColor "${i}"
done

