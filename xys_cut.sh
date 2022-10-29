#!/bin/bash

IFS=$' \t\n'

# set -xv
set -o nounset
set -o errexit
set -o pipefail
set -o noclobber

usage_and_exit(){
   {
      echo '# extract XY data in [X1, X2]'
      echo "${0##*/}" 'X1 X2 < XYS'
   } >&2
   exit "${1:-1}"
}


if [[ $# -ne 2 ]]; then
   usage_and_exit
fi


readonly dir="${0%/*}"


"${dir}"/dawk.sh -v x1="$1" -v x2="$2" '
$1 >= x1{
   if($1 > x2){
      exit
   }
   print $1, $2
}
'
