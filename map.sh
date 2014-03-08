#!/bin/bash

# set -xv
set -o nounset
set -o errexit
set -o pipefail
set -o noclobber

usage_and_exit(){
   {
      echo $(basename "$0") FUNCTION
   } > /dev/stderr
   exit 1
}

if [[ $# -ne 1 ]] || [[ $1 = -h ]] || [[ $1 = --help ]]; then
   usage_and_exit
fi

dawk.sh '
{print('"$1"')}
'
