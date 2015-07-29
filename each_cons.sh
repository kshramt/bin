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
      echo "${0##*/}" N
   } > /dev/stderr
   exit "${1:-1}"
}


if [[ $# -ne 1 ]]; then
   usage_and_exit
fi


if [[ "$1" =~ '^[1-9]+$' ]]; then
   usage_and_exit
fi


if [[ "$1" = 1 ]]; then
   cat
else
   ${MY_AWK:-gawk} -v n="$1" '
BEGIN{
   split("", fs)
   i_now = 0
}
NR < n{
   i_now = (i_now + 1)%n
   fs[i_now] = $0
}
NR >= n{
   i_now = (i_now + 1)%n
   fs[i_now] = $0

   for(i = 1; i < n; i++){
      printf fs[(i_now + i)%n] "\t"
   }
   print $0
}
' || :
fi
