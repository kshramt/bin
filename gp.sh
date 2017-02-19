#!/bin/bash

# set -xv
set -o nounset
set -o errexit
set -o pipefail
set -o noclobber

export IFS=$' \t\n'
export LANG=en_US.UTF-8
umask u=rwx,g=,o=


usage_and_exit(){
   {
      echo "${0##*/}" '<cmd>'
   } >&2
   exit "${1:-1}"
}


t="$(date +%s)"


readonly cmd="$1"
readonly suffix="${2:-png}"

gnuplot -e "set term $suffix; $cmd" > "gp.sh.$t.$suffix"
"${MY_OPEN:-xdg-open}" "gp.sh.$t.$suffix"
