#!/usr/bin/env bash

##
## Initialization code
##
## - Parses options and arguments
## - TODO: performs bash version check
## - Sets bash mode

# Fully resolve base directory: http://stackoverflow.com/a/246128
BASE_DIR=$(d() { (cd -P "$(dirname "$1")" && pwd) }; while [ -h "${S=${BASH_SOURCE[0]}}" ]; do D=$(d "$S"); S=$(readlink "$S"); [[ $S != /* ]] && S="$D/$S"; done; d "$S")
# shellcheck source=functions.sh disable=1091
source "$BASE_DIR/../cmdarg/cmdarg.sh"
# shellcheck disable=2034
CMDARG_ERROR_BEHAVIOR=exit

# If this function exists it will specify script-specific arguments/options
declare -f set_flags > /dev/null && set_flags

cmdarg_info "author" "Sander Bouwhuis <sanderb@gmail.com>"
# cmdarg_info "copyright" "(C) 2015"
cmdarg_parse "$@"

# Enable strict checking after cmdarg has finished
# http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -Eefuo pipefail

##
## Helper functions
##

# Prompt for user input by asking a question
ask () {
  read -p "$* " -r
  echo "$REPLY"
}

# Read input and assume a positive response
yn () {
  [[ ! $(ask "$*" "[Yn]") =~ ^[Nn].* ]]
}

# Read input and assume a negative response
ny () {
  [[ $(ask "$*" "[yN]") =~ ^[Yy].* ]]
}
