#!/bin/bash -eE

ask () {
  read -p "$*" -r
  echo "$REPLY"
}

yn () {
  [[ ! $(ask "$*" "[Yn]") =~ ^[Nn].* ]]
}

ny () {
  [[ ! $(ask "$*" "[yN]") =~ ^[Yy].* ]]
}
