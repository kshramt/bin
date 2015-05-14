#!/bin/bash

IFS=$' \t\n'

# set -xv
set -o nounset
set -o errexit
set -o pipefail
set -o noclobber

usage_and_exit(){
   {
      echo "${0##*/}" '< KEY_VALUES'
   } > /dev/stderr
   exit 1
}

if [[ $# -ne 0 ]]; then
   usage_and_exit
fi

sed -e 's/[ \t]\+/=/' |
tr '\n' '&' |
sed -e 's/&$//'
