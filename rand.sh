#!/bin/bash

# set -xv
set -o nounset
set -o errexit
set -o pipefail
set -o noclobber

usage_and_exit(){
   {
      echo '# generate uniform random numbers [0, 1)'
      echo $(basename "$0")
   } > /dev/stderr
   exit 1
}

if [[ $# -ne 0 ]]; then
   usage_and_exit
fi

awk '
BEGIN{
   CONVFMT = "%.16g"
   OFMT = "%.16g"
   srand()
   while(1){
      print(rand())
   }
}
'
