#!/bin/bash

# Imports #
source "./stringUtilities.sh"
source "./outputFunctions.sh"

#find . -print0 | xargs -0 cmd -option1 -option2 --
while getopts "d:p:s:r:e:" opt; do
  case $opt in
  d) dirPath="$OPTARG" ;;
  p) pattern="$OPTARG" ;;
  s) search="$OPTARG" ;;
  r) replace="$OPTARG" ;;
  e) fileExt="$OPTARG" ;;
  *)
    prettyPrint "Error: Invalid flag $opt"
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

prettyPrint "The following is an overview of the changes that will be made:"
find "$dirPath" -type f -name "$pattern" | while IFS= read -r original; do
    modified="$(searchReplaceLastMatchOnly "$original" "$search" "$replace")"
    printf "\n%s will be renamed to %s\n" "$original" "$modified"
done
prettyPrint

prettyPrint "Do you wish to continue? (enter y to contine n to quit)"
read -r confirm
if [ "$confirm" != "y" ]; then
  exit 0
fi

find "$dirPath" -type f -name "$pattern" | while IFS= read -r original; do
    modified="$(searchReplaceLastMatchOnly "$original" "$search" "$replace")"
    printf "\nRenaming %s to %s\n" "$original" "$modified"
    mv "$original" "$modified"
done
prettyPrint
