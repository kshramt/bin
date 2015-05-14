#!/bin/bash

IFS=$' \t\n'

# set -xv
set -o nounset
set -o errexit
set -o pipefail
set -o noclobber

usage_and_exit(){
   {
      echo "${0##*/}" '< XYS'
   } >&2
   exit "${1:-1}"
}

if [[ $# -ne 0 ]]; then
   usage_and_exit
fi


readonly dir="$(cd "${0%/*}"; pwd -P)"


AWKPATH="$dir":"${AWKPATH:-}" "$dir"/dawk.sh -v OFS=$'\t' '
NR == 1{
   x = $1
   y = $2
}
NR > 1{
   dx = $1 - x
   print x + 0.5*dx, ($2 - y)/dx
   x = $1
   y = $2
}
'
