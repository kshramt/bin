#!/bin/bash

# set -xv
set -o nounset
set -o errexit
set -o pipefail
set -o noclobber

usage_and_exit(){
   {
      echo '# convert uniform random numbers [0, 1) to standard laplace random numbers'
      echo 'rand.sh |' $(basename "$0")
   } > /dev/stderr
   exit 1
}

if [[ $# -ne 0 ]]; then
   usage_and_exit
fi

dawk.sh '
BEGIN{
   sqrt2 = sqrt(2)
}
{
   x = $1
   if(x < 0.5){
      print(-log(2*(0.5 - x))/sqrt2)
   }else{
      print(log(2*(1 - x))/sqrt2)
   }
}
'
