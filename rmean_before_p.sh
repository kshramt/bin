#!/bin/bash

IFS=$' \t\n'

# set -xv
set -o nounset
set -o errexit
set -o pipefail
set -o noclobber

usage_and_exit(){
   {
      echo '# remove mean before P-arrival'
      echo "${0##*/}" IN_FILE OUT_FILE
   } > /dev/stderr
   exit "${1}"
}

if [[ $# -ne 2 ]]; then
   usage_and_exit 1
fi

readonly IN_FILE="$1"
readonly OUT_FILE="$2"


SAC_DISPLAY_COPYRIGHT=false sac <<EOF
cut b a
r ${IN_FILE}
setbb mean_before_p &1,depmen
cut off
r ${IN_FILE}
sub %mean_before_p
w ${OUT_FILE}
quit
EOF
