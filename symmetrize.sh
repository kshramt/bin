#!/bin/bash

# set -xv
set -o nounset
set -o errexit
set -o pipefail
set -o noclobber

usage_and_exit(){
   {
      echo '# convert [0, 1) -> (-1, 1)'
      echo 'rand.sh |' "${0##*/}"
   } > /dev/stderr
   exit "${1}"
}

if [[ $# -ne 0 ]]; then
   usage_and_exit 1
fi

"${0%/*}"/dawk.sh '
$1 > 0{
   print(2*($1 - 0.5))
}
' || :
