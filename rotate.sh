#!/bin/bash

IFS=$' \t\n'

# set -xv
set -o nounset
set -o errexit
set -o pipefail
set -o noclobber

usage_and_exit(){
   {
      echo '# rotate x-y data <angle> degrees counterclockwise'
      echo "${0##*/}" '<angle> < <file>'
   } >&2
   exit "${1}"
}


if [[ $# -ne 1 ]] || [[ $1 = '-h' ]] || [[ $1 = '--help' ]]; then
   usage_and_exit 1
fi


readonly dir="${0%/*}"


"${dir}"/dawk.sh -v th="$1" '
BEGIN{
   th = th*atan2(1, 0)/90
   c = cos(th)
   s = sin(th)
}
{
   print c*$1 - s*$2, s*$1 + c*$2
}
'
