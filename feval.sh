#!/bin/bash

IFS=$' \t\n'

# set -xv
set -o nounset
set -o errexit
set -o pipefail
set -o noclobber

usage_and_exit(){
   {
      echo '# eval Fortran statements'
      echo "${0##*/}" STATEMENTS
   } > /dev/stderr
   exit "${1}"
}

if [[ $# -ge 1 ]] && ([[ $1 = -h ]] || [[ $1 = --help ]]); then
   usage_and_exit 1
fi

readonly TMP_DIR="$(mktemp -d)"

finalize(){
   rm -fr "${TMP_DIR}"
}

trap finalize EXIT

SRC="${TMP_DIR}"/main.F90
{
   echo program main
   echo   use, intrinsic:: iso_fortran_env
   echo   use, intrinsic:: iso_c_binding
   echo   use, intrinsic:: ieee_arithmetic
   echo   ! implicit none
   if [[ $# -eq 0 ]]; then
      cat
   else
      echo "$@"
   fi
   echo   stop
   echo end program main
} > "${SRC}"
"${0%/*}"/f.sh "${SRC}"
