#!/bin/bash

IFS=$' \t\n'

# set -xv
set -o nounset
set -o errexit
set -o pipefail
set -o noclobber

usage_and_exit(){
   {
      echo "${0##*/}" 'N < FILE'
   } > /dev/stderr
   exit 1
}

if [[ $# -ne 1 ]]; then
   usage_and_exit
fi
if [[ "${1}" = "-h" || "${1}" = '--help' ]]; then
   usage_and_exit
fi


${MY_AWK:-gawk} -v N="${1}" '
BEGIN{
   i = 1
}
{
   for(j = 1; j <= NF; j++){
      if(i >= N){
         print "\t" $j
         i = 1
      }else if(i <= 1){
         printf $j
         i += 1
      }else{
         printf "\t" $j
         i += 1
      }
   }
}
END{
   if(i != 1){
      printf "\n"
   }
}
'
