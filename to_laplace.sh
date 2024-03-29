#!/bin/bash

# set -xv
set -o nounset
set -o errexit
set -o pipefail
set -o noclobber

usage_and_exit(){
   {
      echo '# convert uniform random numbers [0, 1) to standard laplace random numbers'
      echo 'rand.sh |' "${0##*/}"
   } > /dev/stderr
   exit "${1}"
}

if [[ $# -ne 0 ]]; then
   usage_and_exit 1
fi

readonly THIS_DIR="${0%/*}"
"${THIS_DIR}"/symmetrize.sh |
"${THIS_DIR}"/dawk.sh '
BEGIN{
   sqrt2 = sqrt(2)
}
{
   x = $1
   if(x >= 0){
      print(-log(1 - x)/sqrt2)
   }else{
      print(log(1 + x)/sqrt2)
   }
}
' || :
