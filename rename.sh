#!/bin/bash

# Imports #
source ~/.bash_functions
source "./stringUtilities.sh"

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

find "$dirPath" -type f -name "$pattern" | while IFS= read -r original; do
    [[ $original != $modified ]] && matchesFound="matchesFound"
    modified="$(searchReplaceLastMatchOnly "$original" "$search" "$replace")"
    [[ $original == $modified ]] || printf "\n%s will be renamed to %s\n" "$original" "$modified"
done

echo "${matchesFound}"

animatedPrint "Do you wish to continue? (enter y to contine n to quit)" .03

read -r confirm

if [ "$confirm" != "y" ]; then
  exit 0
fi

find "$dirPath" -type f -name "$pattern" | while IFS= read -r original; do
    modified="$(searchReplaceLastMatchOnly "$original" "$search" "$replace")"
    printf "\nRenaming %s to %s\n" "$original" "$modified"
    mv "$original" "$modified"
done

animatedPrint "All Done" .03
