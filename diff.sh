#!/bin/bash

IFS=$' \t\n'

# set -xv
set -o nounset
set -o errexit
set -o pipefail
set -o noclobber

usage_and_exit(){
   {
      echo "$(basename "${0}")" '< XYS'
   } >&2
   exit "${1:-1}"
}

if [[ $# -ne 0 ]]; then
   usage_and_exit
fi


readonly dir="$(cd "${0%/*}"; pwd -P)"


"$dir"/dawk.sh -v OFS=$'\t' '
NR == 1{
   x1 = $1
   y1 = $2
}
NR > 1{
   dx = $1 - x
   print x + 0.5*dx, ($2 - y)/dx
   x = $1
   y = $2
}
'