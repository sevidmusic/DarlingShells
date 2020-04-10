#!/bin/bash

text=$( echo "${1}" | sed -E "s/ /_/g;")
for (( i=0; i< ${#text}; i++ )); do
    printf "%s" ${text:$i:1}
    sleep $2
done
