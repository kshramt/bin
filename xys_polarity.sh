#!/bin/bash

IFS=$' \t\n'

# set -xv
set -o nounset
set -o errexit
set -o pipefail
set -o noclobber

usage_and_exit(){
   {
      echo "$(basename "${0}")" "START END < XYS"
   } >&2
   exit "${1:-1}"
}


if [[ $# -ne 2 ]]; then
   usage_and_exit
fi


readonly dir="$(cd "${0%/*}"; pwd -P)"


"$dir"/xys_cut.sh "$1" "$2" |
   cut -f2 |
   sum.sh | (
      read sum
      "$dir"/dawk.sh -v sum="$sum" '
BEGIN{
   if(sum >= 0){
      print 1
   }else{
      print -1
   }
}
'
   )
