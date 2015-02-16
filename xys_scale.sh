#!/bin/bash

IFS=$' \t\n'

# set -xv
set -o nounset
set -o errexit
set -o pipefail
set -o noclobber

usage_and_exit(){
   {
      echo '# rescale XY data to make `max(abs(YS)) == 1`.'
      echo "$(basename "${0}")" 'XYS'
      echo "$(basename "${0}")" '< XYS'
   } >&2
   exit "${1:-1}"
}


readonly dir="$(cd "${0%/*}"; pwd -P)"


if [[ $# -eq 1 ]]; then
   if [[ "$1" = --help ]] || [[ "$1" = -h ]]; then
      usage_and_exit
   else
      "$dir"/dawk.sh '
function abs(x){
   if(x < 0){
      return -x
   }else{
      return x
   }
}
BEGIN{
   max = 0
}
{
   abs_y = abs($2)
   if(abs_y > max){
      max = abs_y
   }
}
END{
   print max
}
' < "$1" | (
         read a
         "$dir"/dawk.sh -v OFS=$'\t' -v a="$a" '
{
   print $1, $2/a
}
' < "$1"
      )
   fi
elif [[ $# -eq 0 ]]; then
      readonly tmp_dir="$(mktemp -d)"
      finalize(){
         rm -fr "${tmp_dir}"
      }
      trap finalize EXIT
      cat >| "$tmp_dir"/input.xy
      "$0" "$tmp_dir"/input.xy
else
   usage_and_exit
fi
