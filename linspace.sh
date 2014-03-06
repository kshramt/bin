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
   if [[ $3 -le 2 ]]; then
      usage_and_exit
   else

      dx=$(
         awk \
            -v x1="$1" \
            -v x2="$2" \
            -v nx="$3" \
            '
         BEGIN{
            CONVFMT = "%.16g"
            OFMT = "%.16g"
            print((x2 - x1)/(nx - 1))
         }'
      )

      seq "$1" "${dx}" $(awk -v dx="${dx}" -v x2="$2" 'BEGIN{CONVFMT = "%.16g"; OFMT = "%.16g"; print(x2 - dx)}')
      echo "$2"
   fi
else
   usage_and_exit
fi
