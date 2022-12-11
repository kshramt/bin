#!/bin/bash

IFS=$' \t\n'

# set -xv
set -o nounset
set -o errexit
set -o pipefail
set -o noclobber

usage_and_exit(){
   {
      echo '# y - mean(y(x1 <= x <= x2))'
      echo "${0##*/}" 'XYS X1 X2'
      echo "${0##*/}" 'X1 X2 < XYS'
   } >&2
   exit "${1}"
}


readonly dir="${0%/*}"


if [[ $# -eq 3 ]]; then
   "${dir}"/xys_cut.sh "$2" "$3" < "$1" |
      gawk '{print $2}' |
      "${dir}"/mean.sh |
      (
         read -r offset
         "${dir}"/dawk.sh -v offset="${offset}" '
{
   print $1, $2 - offset
}
' < "$1"
      )
elif [[ $# -eq 2 ]]; then
   readonly tmp_dir="$(mktemp -d)"
   finalize(){
      rm -fr "${tmp_dir}"
   }
   trap finalize EXIT
   cat >| "${tmp_dir}"/input.xy
   "$0" "${tmp_dir}"/input.xy "$1" "$2"
else
   usage_and_exit 1
fi
