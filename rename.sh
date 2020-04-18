#!/bin/bash

# Imports #
source ~/.bash_functions
source "./stringUtilities.sh"

#find . -print0 | xargs -0 cmd -option1 -option2 --
while getopts "d:p:s:r:e:h" opt; do
  case $opt in
  d) dirPath="$OPTARG" ;;
  p) pattern="$OPTARG" ;;
  s) search="$OPTARG" ;;
  r) replace="$OPTARG" ;;
  e) fileExt="$OPTARG" ;;
  h) printf "\n\nThis utility searches a directory for files whose names match a pattern, and performs a search and replace on each matching file's filename.\n\nFlags:\n\n-d <arg> Directory to search in.\n\n-p <arg> Pattern to match files against\n\n-s <arg> Search pattern, i.e., what is to be replaced.\n\n-r <arg> Replace pattern, i.e., what will replace search pattern.\n\n-e <arg> File extension, this limits search to files with specified extension.\n\n" && exit ;;
  *)
    showLoadingBar "Error: Invalid flag $opt" "dontClear"
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

showLoadingBar "The following is an overview of the changes that will be made:" "dontClear"
find "$dirPath" -type f -name "$pattern" | while IFS= read -r original; do
    modified="$(searchReplaceLastMatchOnly "$original" "$search" "$replace")"
    printf "\n%s will be renamed to %s\n" "$original" "$modified"
done

showLoadingBar "Do you wish to continue? (enter y to contine n to quit)" "dontClear"
read -r confirm
if [ "$confirm" != "y" ]; then
  exit 0
fi

find "$dirPath" -type f -name "$pattern" | while IFS= read -r original; do
    modified="$(searchReplaceLastMatchOnly "$original" "$search" "$replace")"
    printf "\nRenaming %s to %s\n" "$original" "$modified"
    mv "$original" "$modified"
done
showLoadingBar "All Done" "dontClear"
