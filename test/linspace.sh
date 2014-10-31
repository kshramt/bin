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

readonly ret="$("$target" 0 1 11)"
readonly expected="0
0.1
0.2
0.3
0.4
0.5
0.6
0.7
0.8
0.9
1"

[[ "$ret" = "$expected" ]]
