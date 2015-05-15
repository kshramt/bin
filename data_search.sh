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


if [[ $# -ne 2 ]] || [[ "$1" = '-h' ]] || [[ "$1" = '--help' ]]; then
   usage_and_exit
fi


readonly data_dir_base="${MY_DATA_DIR:-"$HOME"/d/data}"
readonly data_dir="$data_dir_base"/hash
readonly uri="$1"
readonly file="$2"
readonly file_uri="$file	$uri"


while read d
do
   if grep -q "^$file_uri$" "$data_dir"/"$d"/file_uri.tsv; then
      echo "$data_dir"/"$d"
   fi
done < <(ls -U -1 "$data_dir")
