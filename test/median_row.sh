#!/bin/bash

IFS=$' \t\n'

# set -xv
set -o nounset
set -o errexit
set -o pipefail
set -o noclobber

readonly target="$(dirname "${0}")"/../"$(basename "${0}")"

trap finalize EXIT

finalize(){
   if [[ $? = 0 ]]; then
      echo PASS "${0}"
   else
      echo FAIL "${0}" > /dev/stderr
      exit $?
   fi
}

if echo | "$target"; then
   false
fi
[[ "$(echo -1 1 | "$target")" = 0 ]]
[[ "$(echo 1 -1 | "$target")" = 0 ]]
[[ "$(echo 1 -1 2 | "$target")" = 1 ]]
[[ "$(echo 1 2 -1 | "$target")" = 1 ]]
