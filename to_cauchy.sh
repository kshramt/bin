#!/bin/bash

# set -xv
set -o nounset
set -o errexit
set -o pipefail
set -o noclobber

usage_and_exit(){
   {
      echo '# convert uniform random numbers [0, 1) to cauchy random numbers'
      echo 'rand.sh |' "${0##*/}"
   } > /dev/stderr
   exit 1
}

if [[ $# -ne 0 ]]; then
   usage_and_exit
fi

readonly THIS_DIR="${0%/*}"
"${THIS_DIR}"/symmetrize.sh |
"${THIS_DIR}"/dawk.sh '
BEGIN{
   half_pi = atan2(1, 0)
}
{
   x = half_pi*$1
   print(sin(x)/cos(x))
}
' || :

