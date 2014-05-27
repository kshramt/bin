#!/bin/bash

IFS=$' \t\n'

# set -xv
set -o nounset
set -o errexit
set -o pipefail
set -o noclobber


usage_and_exit(){
   {
      echo "$(basename "$0")" '< FILE'
   } > /dev/stderr
   exit 1
}


if [[ $# -ne 0 ]]; then
   usage_and_exit
fi


hexdump -v -e '/1 "%02X\n"' | sed -e 's/^/%/' | sed -e 's/^%20$/\+/' | tr -d '\n'
