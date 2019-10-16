# This file should be renamed to stringUtilities.sh

# The functions in this file are designed as utilities for working with strings
# in bash/shell scripts.
function searchReplace() {
  # Note Spaces are used as default to prevent
  # the following error "sed: -e expression #1, char 0: no previous regular expression"
  # This error was noticed in development when default was set to empty string, setting
  # default to space for all vars fixed this error.
  target=${1:- }
  search=${2:- }
  replace=${3:- }
  result="$(printf "%s" "$target" | sed "s/${search}/${replace}/g")"
  printf "%s" "$result"
}

# Revised based on answer from Jesse_b on stack overflow:
# @see https://unix.stackexchange.com/questions/546208/sed-in-not-honoring-the-address-char-when-i-try-to-only-match-last-occurrence?noredirect=1#comment1013405_546208
function searchReplaceLastMatchOnly() {
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
