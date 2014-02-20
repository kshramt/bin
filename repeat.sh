#!/bin/bash

# set -xv
set -o nounset
set -o errexit
set -o pipefail
set -o noclobber

usage_and_exit(){
   echo $(basename "${0}") N ARGS > /dev/stderr
   exit 1
}

if [[ $# -lt 2 ]]; then
   usage_and_exit
fi

N="$1"
shift

i=0
while [[ $i -lt $N ]]
do
   echo "$@"
   ((i++))
done
