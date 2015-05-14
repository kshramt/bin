#!/bin/bash

# set -xv
set -o nounset
set -o errexit
set -o pipefail
set -o noclobber

usage_and_exit(){
   echo ${0##*/} "p < FILE"
   exit 1
}

if [[ $# -ne 1 ]] || [[ $1 = "-h" ]] || [[ $1 = "--help" ]]; then
   usage_and_exit
fi

awk -v p="$1" '
BEGIN{
   srand()
}
{
   if(rand() < p){
      print($0)
   }
}
' || :
