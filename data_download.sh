#!/bin/bash

IFS=$' \t\n'

# set -xv
set -o nounset
set -o errexit
set -o pipefail
set -o noclobber

usage_and_exit(){
   {
      echo "${0##*/}" '<uri>'
   } >&2
   exit "${1:-1}"
}

readonly tmp_dir="$(mktemp -d)"

finalize(){
   rm -fr "${tmp_dir}"
}

trap finalize EXIT


if [[ $# -ne 1 ]] || [[ "$1" = '-h' ]] || [[ "$1" = '--help' ]]; then
   usage_and_exit
fi


readonly data_dir_base="${MY_DATA_DIR:-"$HOME"/d/data}"
readonly data_dir="$data_dir_base"/hash
readonly uri="$1"


cd "$tmp_dir"
wget "$uri"
while read file
do
   hash="$(sha512sum "$file" | awk '{printf $1}')"
   mkdir -p "$data_dir"/"$hash"
   cd "$data_dir"/"$hash"
   file_uri="$file	$uri"
   if grep "^$file_uri$" file_uri.tsv; then
      :
   else
      if [[ ! -e data ]]; then
         mv "$tmp_dir"/"$file" data
         chmod oug-w data
      fi
      echo "$file_uri" >> file_uri.tsv
   fi
   echo "$data_dir_base	$hash	$file_uri"
done < <(find . -type f | sed -e 's|^\./||g')
