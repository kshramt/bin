#!/bin/bash

# set -xv
set -o nounset
set -o errexit
set -o pipefail
set -o noclobber

usage_and_exit(){
   {
      echo $(basename "${0}") '< FILE'
   } > /dev/stderr
   exit 1
}

if [[ $# -ne 0 ]]; then
   usage_and_exit
fi

for m in $(fort_deps.sh | grep -v ifport)
do
   echo "${m}"
   fort_deps_recursive.sh < "${m}.F90"
done
