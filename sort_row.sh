#!/bin/bash

IFS=$' \t\n'

# set -xv
set -o nounset
set -o errexit
set -o pipefail
set -o noclobber

usage_and_exit(){
   {
      echo "${0##*/}" '< FILE'
   } > /dev/stderr
   exit "${1}"
}


"${0%/*}"/dawk.sh '
{
   split("", fs)
   for(i = 1; i <= NF; i++){
      fs[i] = $i
   }
   asort(fs, sorted_fs)
   buf = ""
   for(i = 1; i < NF; i++){
      buf = buf sorted_fs[i] "\t"
   }
   if(0 < NF){
      print buf sorted_fs[NF]
   }else{
      print
   }
}
'
