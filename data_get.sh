#!/bin/bash

IFS=$' \t\n'

# set -xv
set -o nounset
set -o errexit
set -o pipefail
set -o noclobber

usage_and_exit(){
   {
      echo "${0##*/}" '<uri> <file>'
   } >&2
   exit "${1:-1}"
}


if [[ $# -ne 2 ]]; then
   usage_and_exit
fi


readonly dir="${0%/*}"
readonly uri="$1"
readonly file="$2"
readonly file_base="$(basename "$file")"

d="$("$dir"/data_search.sh "$uri" "$file_base")"
if [[ -z "$d" ]]; then
   "$dir"/data_download.sh "$uri" > /dev/null
   d="$("$dir"/data_search.sh "$uri"  "$file_base")"
fi
[[ ! -z "$d" ]] # exist?
[[ "$(echo "$d" | wc -l)" -eq 1 ]] # unique?
echo "$d"
