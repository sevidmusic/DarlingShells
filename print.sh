#!/bin/bash

STRING="Hello"
for (( i=0; i< ${#STRING}; i++ )); do
    printf "%s" "${i}"
    sleep 1;
done
