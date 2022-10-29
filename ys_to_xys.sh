#!/bin/bash

IFS=$' \t\n'

# set -xv
set -o nounset
set -o errexit
set -o pipefail
set -o noclobber

usage_and_exit(){
   {
      echo "${0##*/}" 't0 dt < YS >| XYS'
   } >&2
   exit "${1:-1}"
}


if [[ $# -ne 2 ]]; then
   usage_and_exit
fi


readonly dir="${0%/*}"


"${dir}"/dawk.sh -v t0="$1" -v dt="$2" '
{
   print t0 + (NR - 1)*dt, $0
}
'
