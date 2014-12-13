#!/bin/bash

IFS=$' \t\n'

# set -xv
set -o nounset
set -o errexit
set -o pipefail
set -o noclobber

usage_and_exit(){
   {
      echo '# n >= 1'
      echo "$(basename "${0}")" N
   } > /dev/stderr
   exit "${1:-1}"
}


if [[ $# -ne 1 ]]; then
   usage_and_exit
fi


if [[ "${1:0:1}" = '-' ]]; then
   usage_and_exit
fi


if [[ "$1" = 1 ]]; then
   cat
else
   awk -v n="$1" '
BEGIN{
   split("", fs)
   n_1 = n - 1
}
NR < n{
   fs[NR] = $0
}
NR >= n{
   printf fs[1] "\t"
   for(i = 2; i < n; i++){
      fsi = fs[i]
      printf fsi "\t"
#print i > "/dev/stderr"
      fs[i - 1] = fsi
   }
   print $0
   fs[n_1] = $0
}
'
fi

