#!/bin/bash

text="Hello"
for (( i=0; i< ${#text}; i++ )); do
    printf "%s" ${text:$i:1}
    sleep 1
done
