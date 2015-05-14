#!/bin/bash

IFS=$' \t\n'

# set -xv
set -o nounset
set -o errexit
set -o pipefail
set -o noclobber

usage_and_exit(){
   {
      echo '# `chnhdr` a binary format SAC file.'
      echo "${0##*/}" '<in_file> <field> <value> [<out_file>]'
   } > /dev/stderr
   exit 1
}

if [[ $# -eq 3 ]]; then
   readonly out_file="$1"
elif [[ $# -eq 4 ]]; then
   readonly out_file="$4"
else
   usage_and_exit
fi

readonly in_file="$1"
readonly field="$2"
readonly value="$3"

${MY_SAC:-sac} <<EOF
r ${in_file}
chnhdr ${field} ${value}
w ${out_file}
quit
EOF
