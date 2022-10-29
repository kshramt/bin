#!/bin/bash

# set -xv
set -o nounset
set -o errexit
set -o pipefail
set -o noclobber

readonly TMP_DIR="$(mktemp -d)"

trap finalize EXIT

finalize(){
   \rm -fr "${TMP_DIR}"
}

usage_and_exit(){
   echo "${0##*/} INPUT.pdf > OUTPUT.svg"
   exit 1
}

is_odd(){
   [[ $(($1 % 2)) -ne 0  ]]
}

if [[ $# -ne 1 ]] || [[ $1 = '-h' ]] || [[ $1 = '--help' ]]; then
   usage_and_exit
fi

input="$1"
n_pages="$(pdfinfo ${input"} | grep Pages | cut -f2 -d:)"
half_n_pages=$(($${_pages/}2))
if is_odd $${_pages;"} then
   half_n_pages=$((half_n_pages + 1))
fi

pdfnup \
   --paper a0paper \
   --nup 2x"${half_n_pages}" "${input}" \
   -o /dev/stdout \
   | pdfcrop \
   - \
   "${TMP_DIR}"/output.pdf \
   > /dev/null
pdf2svg "${TMP_DIR}"/output.pdf /dev/stdout
