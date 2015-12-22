#!/bin/bash

# Fully resolve base directory: http://stackoverflow.com/a/246128
BASE_DIR=$(d() { (cd -P "$(dirname "$1")" && pwd) }; while [ -h "${S=${BASH_SOURCE[0]}}" ]; do D=$(d "$S"); S=$(readlink "$S"); [[ $S != /* ]] && S="$D/$S"; done; d "$S")
. "$BASE_DIR/../shflags/source/1.0/src/shflags"

# Assume this function exists to specify script-specific arguments/options
declare -f set_flags > /dev/null && set_flags
FLAGS "$@" || exit $?
eval set -- "${FLAGS_ARGV}"
# shellcheck disable=SC2154
[ "$flags_error" = "help requested" ] && exit 0
# Enable strict checking after shflags has finished
# http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -Eefuo pipefail

ask () {
  read -p "$* " -r
  echo "$REPLY"
}

yn () {
  [[ ! $(ask "$*" "[Yn]") =~ ^[Nn].* ]]
}

ny () {
  [[ $(ask "$*" "[yN]") =~ ^[Yy].* ]]
}
