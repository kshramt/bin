#!/bin/bash

# set -xv
set -o nounset
set -o errexit
set -o pipefail
set -o noclobber

usage_and_exit(){
   {
      echo $(basename "$0") INIT FUNCTION
   } > /dev/stderr
   exit 1
}

if [[ $# -ne 2 ]]; then
   usage_and_exit
fi

dawk.sh -v ret="$1" '
{'"$2"'}
END{
   print(ret)
}
'
