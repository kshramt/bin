#!/bin/bash

IFS=$' \t\n'

# set -xv
set -o nounset
set -o errexit
set -o pipefail
set -o noclobber

usage_and_exit(){
   {
      echo '# compile and execute'
      echo "${0##*/}" FILE.F90
   } > /dev/stderr
   exit "${1}"
}

if [[ $# -ne 1 ]]; then
   usage_and_exit 1
fi

SRC="$1"
EXE="${SRC}".exe

${MY_FC} "${MY_FFLAGS_COMMON}" "${MY_FFLAGS_DEBUG}" -o "${EXE}" "${SRC}"
if [[ "${SRC}" == /* ]]; then
   "${EXE}"
else
   ./"${EXE}"
fi
