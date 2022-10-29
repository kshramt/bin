#!/bin/bash

IFS=$' \t\n'

# set -xv
set -o nounset
set -o errexit
set -o pipefail
set -o noclobber

usage_and_exit(){
   {
      echo "# Vertices (X1, Y1), (X2, Y2), (X3, Y3), (X4, Y4) should be given in counterclockwise order."
      echo "# Convexity is not checked."
      echo "${0##*/}" 'ROW_X ROW_Y X1 Y1 X2 Y2 X3 Y3 X4 Y4 < POINTS'
   } > /dev/stderr
   exit "${1}"
}

if [[ $# -ne 10 ]]; then
   usage_and_exit 1
fi


"${0%/*}"/dawk.sh \
   -v ROW_X="${1}" -v ROW_Y="${2}" \
   -v X1="${3}" -v Y1="${4}" \
   -v X2="${5}" -v Y2="${6}" \
   -v X3="${7}" -v Y3="${8}" \
   -v X4="${9}" -v Y4="${10}" \
   '
function is_in(x, y){
   x1 = X1 - x
   x2 = X2 - x
   x3 = X3 - x
   x4 = X4 - x
   y1 = Y1 - y
   y2 = Y2 - y
   y3 = Y3 - y
   y4 = Y4 - y
   return \
      x1*y2 - y1*x2 >= 0 &&
      x2*y3 - y2*x3 >= 0 &&
      x3*y4 - y3*x4 >= 0 &&
      x4*y1 - y4*x1 >= 0
}
{
   if(is_in($ROW_X, $ROW_Y)){
      print $0
   }
}
'
