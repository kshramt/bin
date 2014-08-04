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
      exit 1
   }else{
      split("", fs)
      for(i = 1; i <= NF; i++){
         fs[i] = $i
      }
      asort(fs, sorted_fs)
      if(NF%2 == 0){
         print 0.5*(sorted_fs[NF/2] + sorted_fs[NF/2 + 1])
      }else{
         print sorted_fs[(NF + 1)/2]
      }
   }
}
'
