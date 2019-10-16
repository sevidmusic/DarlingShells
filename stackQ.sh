#!/bin/bash
# Search and replace using command: sed "s/${search}/${replace}/g")"
# This works, but is not what i want, i just need last occurence.
function searchReplace() {
    # spaces are set as defaults
    target=${1:- }
    search=${2:- }
    replace=${3:- }
    result="$(printf "%s" "$target" | sed "s/${search}/${replace}/g")"
    printf "%s" "$result"
}

# Search and replace using command: sed "s/${search}$/${replace}/g")"
# This is what I have read should work, using $ should only match
# last occurence, this is what I want but it does not work.
function searchReplaceLastMatchOnly() {
    # spaces are set as defaults
    target=${1:- }
    search=${2:- }
    replace=${3:- }
    ### sed NOT WORKING WITH $ ###
    result="$(printf "%s" "$target" | sed "s/${search}$/${replace}/g")"
    printf "%s" "$result"
}
# Revised based on answer from Jesse_b on stack overflow:
# @see https://unix.stackexchange.com/questions/546208/sed-in-not-honoring-the-address-char-when-i-try-to-only-match-last-occurrence?noredirect=1#comment1013405_546208
function searchReplaceLastMatchOnlyRevised() {
  # spaces are set as defaults
  local target
  target=$(rev <<<"${1:- }")
  local search
  search=$(rev <<<"${2:- }")
  local replace
  replace=$(rev <<<"${3:- }")
  local esearch
  esearch=$(printf '%s\n' "$search" | sed 's:[][\/.^$*]:\\&:g')
  local ereplace
  ereplace=$(printf '%s\n' "$replace" | sed 's:[\/&]:\\&:g;$!s/$/\\/')
  result="$(printf "%s" "$target" | sed "s/${esearch}/${ereplace}/" | rev)"
  printf "%s" "$result"
}

# demo
search="bar"
replace="Bar"
dirPath="."
pattern="*.txt"
printf "\n### Using searchReplaceLastMatchOnly() ###\n"
find "$dirPath" -type f -name "$pattern" | while IFS= read -r original; do
    modified="$(searchReplaceLastMatchOnly "$original" "$search" "$replace")"
    printf "\nRenaming %s to %s\n" "$original" "$modified"
    #mv "$original" "$modified"
done
printf "\n"

# Currently this has following results:
#
# Renaming ./bar/baz/foobar.txt to ./bar/baz/foobar.txt
#
# Renaming ./bar/foobar.txt to ./bar/foobar.txt
#

printf "\n### Using searchReplace() ###\n"
find "$dirPath" -type f -name "$pattern" | while IFS= read -r original; do
    modified="$(searchReplace "$original" "$search" "$replace")"
    printf "\nRenaming %s to %s\n" "$original" "$modified"
    #mv "$original" "$modified"
done
printf "\n"

# Currently this has following results:
#
# Renaming ./bar/baz/foobar.txt to ./Bar/baz/fooBar.txt
#
# Renaming ./bar/foobar.txt to ./Bar/fooBar.txt

printf "\n### Using searchReplaceLastMatchOnlyRevised() ###\n"
find "$dirPath" -type f -name "$pattern" | while IFS= read -r original; do
    modified="$(searchReplaceLastMatchOnlyRevised "$original" "$search" "$replace")"
    printf "\nRenaming %s to %s\n" "$original" "$modified"
    #mv "$original" "$modified"
done
printf "\n"

# Currently this has following results:
#
# Renaming ./bar/baz/foobar.txt to ./bar/baz/fooBar.txt
#
# Renaming ./bar/foobar.txt to ./bar/fooBar.txt
#
# This Works! : )
