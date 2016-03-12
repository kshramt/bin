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
      echo "${0##*/}" "< <english.txt> | grep -i --only-matching --extended-regexp '([^ ]+ ){5}in order to be able to( [^ ]+){5}'"
   } >&2
   exit "${1:-1}"
}


if [[ $# -ne 0 ]]; then
   usage_and_exit
fi


sed \
   -e 's/:/ : /g' \
   -e 's/;/ ; /g' \
   -e 's/!/ ! /g' \
   -e 's/\?/ ? /g' \
   -e 's/"/ " /g' \
   -e 's/(/ ( /g' \
   -e 's/)/ ) /g' \
   -e 's/,/ , /g' \
   -e 's/\./ . /g' \
   |
   tr '\n\t\r\f' '    ' |
   tr -s ' '
