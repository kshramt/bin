#!/bin/bash

IFS=$' \t\n'

# set -xv
set -o nounset
set -o errexit
set -o pipefail
set -o noclobber

usage_and_exit(){
   {
      echo '# Apply TYPE taper for [0, R] and [(1 - R), 1], where 0 < R <= 0.5'
      echo '# TYPE: cos'
      echo "$(basename "${0}")" 'TYPE R < XYS'
      echo "$(basename "${0}")" 'XYS TYPE R'
   } >&2
   exit "${1:-1}"
}


readonly dir="$(cd "${0%/*}"; pwd -P)"


if [[ $# -eq 3 ]]; then
   "$dir"/dawk.sh -v r="$3" '
BEGIN{
   if(r <= 0 || 0.5 < r){
      print "0 < r <= 0.5 not satisfied: " r > "/dev/stderr"
      exit 1
   }
}
'

   x1="$(head -n1 "$1" | "$dir"/dawk.sh '{print $1}')"
   x2="$(tail -n1 "$1" | "$dir"/dawk.sh '{print $1}')"
   if [[ "$2" = cos ]]; then
      "$dir"/dawk.sh -v OFS=$'\t' -v x1="$x1" -v x2="$x2" -v r="$3" '
BEGIN{
   dx = r*(x2 - x1)
   xl = x1 + dx
   xu = x2 - dx
   pi_per_dx = 2*atan2(1, 0)/dx
   offset_head = -x1 - dx
   offset_tail = -x2 + dx
}
{
   if($1 <= xl){
      print $1, $2*0.5*(cos(pi_per_dx*($1 + offset_head)) + 1)
   }else if(xu <= $1){
      print $1, $2*0.5*(cos(pi_per_dx*($1 + offset_tail)) + 1)
   }else{
      print $1, $2
   }
}
' "$1"
   else
      usage_and_exit
   fi
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
