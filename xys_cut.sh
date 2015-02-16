#!/bin/bash

IFS=$' \t\n'

# set -xv
set -o nounset
set -o errexit
set -o pipefail
set -o noclobber

usage_and_exit(){
   {
      echo '# extract XY data in [START, END]'
      echo "$(basename "${0}")" 'START END < XYS'
   } >&2
   exit "${1:-1}"
}


if [[ $# -ne 2 ]]; then
   usage_and_exit
fi


readonly dir="$(cd "${0%/*}"; pwd -P)"


"$dir"/dawk.sh -v OFS=$'\t' -v start="$1" -v end="$2" '
$1 >= start{
   if($1 > end){
      exit
   }
   print $1, $2
}
'
