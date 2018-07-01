#!/bin/bash

IFS=$' \t\n'
umask u=rwx,g=,o=


# set -xv
set -o nounset
set -o errexit
set -o pipefail
set -o noclobber

usage_and_exit(){
   {
      echo "${0##*/}" '<columns...>'
   } >&2
   exit "${1:-1}"
}


if [[ $# -lt 1 ]] || [[ "$1" = -h ]] || [[ "$1" = --help ]]; then
   usage_and_exit
fi


awk_expr='{print '
for arg in "$@"
do
   awk_expr="$awk_expr"'$'"$arg"','
done
awk_expr="${awk_expr%,}"'}'


${MY_AWK:-awk} -v OFS=$'\t' "$awk_expr"
