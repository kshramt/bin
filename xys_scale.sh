#!/bin/bash

IFS=$' \t\n'

# set -xv
set -o nounset
set -o errexit
set -o pipefail
set -o noclobber

usage_and_exit(){
   {
      echo '# y/max(abs(y(x1 <= x <= x2)))'
      echo "$(basename "${0}")" 'XYS X1 X2'
      echo "$(basename "${0}")" 'X1 X2 < XYS'
   } >&2
   exit "${1:-1}"
}


readonly dir="$(cd "${0%/*}"; pwd -P)"


if [[ $# -eq 3 ]]; then
   "$dir"/xys_cut.sh "$2" "$3" < "$1" |
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
' | (
      read a
      "$dir"/dawk.sh -v OFS=$'\t' -v a="$a" '
{
   print $1, $2/a
}
' < "$1"
   )
elif [[ $# -eq 2 ]]; then
      readonly tmp_dir="$(mktemp -d)"
      finalize(){
         rm -fr "${tmp_dir}"
      }
      trap finalize EXIT
      cat >| "$tmp_dir"/input.xy
      "$0" "$tmp_dir"/input.xy "$1" "$2"
else
   usage_and_exit
fi
