#!/bin/bash

# set -xv
set -o nounset
set -o errexit
set -o pipefail
set -o noclobber

usage_and_exit(){
   echo ${0##*/} "N < FILE"
   exit 1
}

if [[ $# -ne 1 ]] || [[ $1 = "-h" ]] || [[ $1 = "--help" ]]; then
   usage_and_exit
fi

${MY_AWK:-awk} -v N="$1" '
BEGIN{
   i = N
}
{
   if(i >= N){
      print $0
      i = 0
   }
   i += 1
}
' || :
