#!/bin/bash

IFS=$' \t\n'

# set -xv
set -o nounset
set -o errexit
set -o pipefail
set -o noclobber

usage_and_exit(){
   {
      echo "${0##*/}" '<prefix> <args*>'
   } >&2
   exit "${1}"
}

if [[ $# -lt 1 ]]; then
   usage_and_exit 1
fi

prefix="$1"
shift

${MY_OPEN:-xdg-open} "${prefix}$(echo -n "$@" | "${0%/*}"/encode_uri.sh)"
