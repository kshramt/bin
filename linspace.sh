#!/bin/bash

# set -xv
set -o nounset
set -o errexit
set -o pipefail
set -o noclobber

usage_and_exit(){
   {
      echo $(basename "$0") X1 X2 NX
   } > /dev/stderr
   exit 1
}

if [[ $# -eq 2 ]]; then
   "$0" "$1" "$2" 50
elif [[ $# -eq 3 ]]; then
   if [[ $3 -lt 2 ]]; then
      usage_and_exit
   else

      seq 0 $(( $3 - 2 )) |
      awk \
         -v x1="$1" \
         -v x2="$2" \
         -v nx="$3" \
         '
         BEGIN{
            CONVFMT = "%.16g"
            OFMT = "%.16g"
            dx = (x2 - x1)/(nx - 1)
         }
         {
            print(x1 + dx*$1)
         }'
      echo "$2"
   fi
else
   usage_and_exit
fi
