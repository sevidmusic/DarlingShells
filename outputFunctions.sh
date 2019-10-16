## Output Functions ##

# Prints via printf with wrapping newline(\n) chars.
# Note: If no arguments are supplied, pretty print
#       will simpy print a default string followed by
#       a newline character (\n).
# Usage Exmple:
# txt="Text"
# prettyPrint "$txt"
function prettyPrint() {
  # Set default text to print in case no arguments were passed
  # (at the moment this is an empty string)
  text=${1:-}
  [[ -z $text ]] && printf "\n" || printf "\n%s\n" "$text"
  #
}
