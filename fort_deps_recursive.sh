#!/bin/bash

IFS=$' \t\n'

# set -xv
set -o nounset
set -o errexit
set -o pipefail
set -o noclobber

usage_and_exit(){
   {
      echo "${0##*/}" '< <f90-file>'
   } >&2
   exit "${1:-1}"
}

readonly dir="$(cd "${0%/*}"; pwd -P)"


if [[ $# -ne 0 ]]; then
   usage_and_exit
fi


main(){
   for m in $("${dir}"/fort_deps.sh)
   do
      echo "${m}"
      main < "${m}".f90
   done
}


main | sort -u
