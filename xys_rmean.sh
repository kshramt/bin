#!/bin/bash

IFS=$' \t\n'

# set -xv
set -o nounset
set -o errexit
set -o pipefail
set -o noclobber

usage_and_exit(){
   {
      echo "# subtract mean of Y before X (exclusive) from XY data"
      echo "$(basename "${0}")" 'X XYS'
      echo "$(basename "${0}")" 'X < XYS'
   } >&2
   exit "${1:-1}"
}


readonly dir="$(cd "${0%/*}"; pwd -P)"


if [[ $# -eq 2 ]]; then
   "$dir"/dawk.sh -v x="$1" '
BEGIN{
   sum = 0
}
{
   if($1 >= x){
      exit
   }
   sum += $2
}
END{
   print sum/(NR - 1.0)
}
' < "$2" | (
      read offset
      "$dir"/dawk.sh -v OFS=$'\t' -v offset="$offset" '
{
   print $1, $2 - offset
}
' < "$2"
   )
elif [[ $# -eq 1 ]]; then
   if [[ "$1" = --help ]] || [[ "$1" = -h ]]; then
      usage_and_exit
   else
      readonly tmp_dir="$(mktemp -d)"
      finalize(){
         rm -fr "${tmp_dir}"
      }
      trap finalize EXIT
      cat >| "$tmp_dir"/input.xy
      "$0" "$1" "$tmp_dir"/input.xy
   fi
else
   usage_and_exit
fi
