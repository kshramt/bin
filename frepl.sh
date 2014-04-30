#!/bin/bash

IFS=$' \t\n'

# set -xv
set -o nounset
set -o errexit
set -o pipefail
set -o noclobber

usage_and_exit(){
   {
      echo '# Fortran REPL'
      echo $(basename "$0") STATEMENTS
   } > /dev/stderr
   exit 1
}

if [[ $# -eq 0 ]] || [[ $1 = -h ]] || [[ $1 = --help ]]; then
   usage_and_exit
fi

feval.sh 'print*, ' "$@"
