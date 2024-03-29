#!/bin/bash

IFS=$' \t\n'

# set -xv
set -o nounset
set -o errexit
set -o pipefail
set -o noclobber

usage_and_exit(){
   {
      echo "# return 0 if some of <dep>s are newer than <target>, otherwise 1"
      echo "${0##*/}" '<target>' '[<dep> ...]'
   } >&2
   exit "${1}"
}


[[ $# -eq 0 ]] && usage_and_exit 1


readonly target="$1"
[[ -e "${target}" ]] || exit 0
shift
while [[ $# -gt 0 ]]
do
   [[ "$1" -nt "${target}" ]] && exit 0
   shift
done
exit 1
