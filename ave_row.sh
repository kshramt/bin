#!/bin/bash

IFS=$' \t\n'

# set -xv
set -o nounset
set -o errexit
set -o pipefail
set -o noclobber

usage_and_exit(){
   {
      echo "$(basename "$0")" '< FILE'
   } > /dev/stderr
   exit 1
}

"$(dirname "${0}")"/dawk.sh '
{
   if(NF < 1){
      print 0
   }else{
      sum = 0
      for(i = 1; i <= NF; i++){
         sum += $i
      }
      print sum/NF
   }
}
'