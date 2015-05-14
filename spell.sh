#!/bin/bash

IFS=$' \t\n'

# set -xv
set -o nounset
set -o errexit
set -o pipefail
set -o noclobber

usage_and_exit(){
   {
      echo "${0##*/}" WORD
   } > /dev/stderr
   exit 1
}

if [[ $# -ne 1 ]]; then
   usage_and_exit
fi

agrep -i -y -B "$1" /usr/share/dict/words
