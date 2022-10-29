#!/bin/bash

# set -xv
set -o nounset
set -o errexit
set -o pipefail
set -o noclobber

usage_and_exit(){
   {
      echo "${0##*/}" X1 X2 NX
   } > /dev/stderr
   exit "${1}"
}

if [[ $# -eq 2 ]]; then
   "$0" "$1" "$2" 50
elif [[ $# -eq 3 ]]; then
   if [[ $3 -lt 2 ]]; then
      usage_and_exit 1
   else
      "${0%/*}"/dawk.sh \
         -v x1="$1" \
         -v x2="$2" \
         -v nx="$3" \
         '
         BEGIN{
            dx = (x2 - x1)/(nx - 1)
            for(i = 0; i < nx - 1; i++){
               print(x1 + dx*i)
            }
         }'
      echo "$2"
   fi
else
   usage_and_exit 1
fi
