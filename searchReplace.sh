# Imports #
source "./stringUtilities.sh"
source "./outputFunctions.sh"

while getopts "t:s:r:" opt; do
  case $opt in
    t) target=$OPTARG  ;;
    s) search=$OPTARG  ;;
    r) replace=$OPTARG ;;
    *) prettyPrint "Error: Invalid flag $opt"
       exit 1
  esac
done

printf "\nTarget: %s\nSearch: %s\nReplace: %s\n" "$target" "$search" "$replace"
prettyPrint "Result: $(searchReplace "$target" "$search" "$replace")"
