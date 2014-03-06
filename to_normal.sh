#!/bin/bash

# set -xv
set -o nounset
set -o errexit
set -o pipefail
set -o noclobber

usage_and_exit(){
   {
      echo '# convert uniform random numbers [0, 1) to standard normal random numbers'
      echo 'rand.sh |' $(basename "$0")
   } > /dev/stderr
   exit 1
}

if [[ $# -ne 0 ]]; then
   usage_and_exit
fi

awk '
BEGIN{
   CONVFMT = "%.18g"
   OFMT = "%.18g"
}
{
   if(NR%2 == 1){
      u = 1 - (2*$1)
   }else{
      v = 2*$1 - 1
      w = u**2 + v**2
      if(w <= 1){
         z = sqrt(-2*log(w)/w)
         print u*z
         print v*z
      }
   }
}
'
