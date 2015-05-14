#!/bin/bash

# set -xv
set -o nounset
set -o errexit
set -o pipefail
set -o noclobber

usage_and_exit(){
   {
      echo '# convert uniform random numbers [0, 1) to standard normal random numbers'
      echo 'rand.sh |' ${0##*/}
   } > /dev/stderr
   exit 1
}

if [[ $# -ne 0 ]]; then
   usage_and_exit
fi

"${0%/*}"/dawk.sh '
BEGIN{
   two_pi = 4*atan2(1, 0)
}
{
   if(NR%2 == 1){
      x1 = 1 - $1
   }else{
      x2 = $1
      print sqrt(-2*log(x1))*sin(two_pi*x2)
      print sqrt(-2*log(x1))*cos(two_pi*x2)
   }
}
' || :
