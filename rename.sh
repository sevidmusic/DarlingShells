#!/bin/bash

set -o posix
clear

# Imports #
source ~/.bash_functions
source "./stringUtilities.sh"

setColor 42

while getopts "d:p:s:r:e:h" opt; do
  case $opt in
  d) dirPath="$OPTARG" ;;
  p) pattern="$OPTARG" ;;
  s) search="$OPTARG" ;;
  r) replace="$OPTARG" ;;
  e) fileExt="$OPTARG" ;;
  h) animatedPrint  "This utility searches a directory for files whose names match a pattern, and performs a search and replace on each matching file's filename." .03 && printf "\n\n" && animatedPrint "Flags:" .03 && printf "\n\n" && animatedPrint "-d <arg> Directory to search in." .03 && printf "\n\n" && animatedPrint "-p <arg> Pattern to match files against" .03 && printf "\n\n" && animatedPrint "-s <arg> Search pattern, i.e., what is to be replaced." .03 && printf "\n\n" && animatedPrint "-r <arg> Replace pattern, i.e., what will replace search pattern." .03 && printf "\n\n" && animatedPrint "-e <arg> File extension, this limits search to files with specified extension." .03 && exit ;;
  *)
    animatedPrint "Error: Invalid flag $opt" .03
    exit 1
    ;;
  esac
done

# Defaults #
dirPath=${dirPath:-.}
pattern=${pattern:-*}
search=${search:- }
replace=${replace:- }
fileExt=${fileExt:-txt}

animatedPrint "The following is an overview of the changes that will be made:" .03

numberOfChanges=0

showLoadingBar "Scanning directory ${dirPath} and it's sub directories for pattern ${pattern}" "dontClear"
animatedPrint "The following is an overview of the changes that will be made, these changes will not be made until you confirm" .03

while IFS= read -r original; do
    modified="$(searchReplaceLastMatchOnly "$original" "$search" "$replace")"
    [[ $original == $modified ]] || animatedPrint "${original} will be renamed to ${modified}" .03
    [[ $original == $modified ]] || ((numberOfChanges++))
    printf "\n"
done <<< "$(find "$dirPath" -type f -name "$pattern")"

printf "\n\nNumber of files that will be changed: %s\n\n"  "${numberOfChanges}"

animatedPrint "Do you wish to continue? (enter y to contine n to quit)" .03

read -r confirm

if [ "$confirm" != "y" ]; then
  exit 0
fi

find "$dirPath" -type f -name "$pattern" | while IFS= read -r original; do
    modified="$(searchReplaceLastMatchOnly "$original" "$search" "$replace")"
    printf "\nRenaming %s to %s\n" "$original" "$modified"
    [[ $modified == $original ]] || mv "$original" "$modified"
done

animatedPrint "All Done" .03

setColor 0
