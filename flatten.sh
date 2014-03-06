#!/bin/bash

# set -xv
set -o nounset
set -o errexit
set -o pipefail
set -o noclobber

usage_and_exit(){
   {
      echo $(basename "$0") 
   } > /dev/stderr
   exit 1
}

awk '
BEGIN{
   CONVFMT = "%.16g"
   OFMT = "%.16g"
}
{
   for(i = 1; i < NF + 1; i++){
      print($i)
   }
}
'
