#!/bin/bash

# set -xv
set -o nounset
set -o errexit
set -o pipefail
set -o noclobber


usage_and_exit(){
   {
      echo "${0##*/}" NAME
   } > /dev/stderr
   exit "${1}"
}

if [[ $# -ne 1 ]]; then
   usage_and_exit 1
fi

NAME="$1"
F90="${NAME}".F90
MOD="${NAME}".mod
OBJ="${NAME}".o
EXE="${NAME}".exe
DEPS="$(fort_deps_recursive.sh < "${F90}" | tac)"
MODS=$(echo "${DEPS}" | sed -e '/^$/d' -e 's/$/.mod/' | tr '\n' ' ')
OBJS=$(echo "${DEPS}" | sed -e '/^$/d' -e 's/$/.o/' | tr '\n' ' ')

if [[ "${NAME}" != *_lib ]]; then
   echo "${EXE}: ${OBJS} ${OBJ}" '|' "${MODS}"
   echo -e "\t"'$(FC) -o $@ $^'
fi
echo "${MOD} ${NAME}.o: ${F90}" '|' "${MODS}"
echo -e "\t"'$(FC) -c $<'
echo -e "\ttouch ${MOD}"
