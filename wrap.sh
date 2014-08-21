#!/bin/bash

IFS=$' \t\n'

# set -xv
set -o nounset
set -o errexit
set -o pipefail
set -o noclobber

usage_and_exit(){
   {
      echo "$(basename "$0")" 'N < FILE'
   } > /dev/stderr
   exit 1
}

if [[ $# -ne 1 ]]; then
   usage_and_exit
fi
if [[ "${1}" = "-h" || "${1}" = '--help' ]]; then
   usage_and_exit
fi


"$(dirname "${0}")"/dawk.sh -v N="${1}" '
BEGIN{
   buf = ""
   i = 1
}
{
   for(j = 1; j <= NF; j++){
      if(i >= N){
         print buf $j
         buf = ""
         i = 1
      }else{
         buf = buf $j "\t"
         i += 1
      }
   }
}
'
