#!/bin/bash

IFS=$' \t\n'

\unset -f unalias
\unalias -a
unset -f command

# set -xv
set -o nounset
set -o errexit
set -o pipefail
set -o noclobber

usage_and_exit(){
   {
      echo '# compile and execute'
      echo $(basename "$0") FILE.F90
   } > /dev/stderr
   exit 1
}

if [[ $# -ne 1 ]]; then
   usage_and_exit
fi

SRC="$1"
EXE="${SRC}".exe

${MY_FORTRAN_DEBUG} -o "${EXE}" "${SRC}"
if [[ "${SRC}" == /* ]]; then
   "${EXE}"
else
   ./"${EXE}"
fi
