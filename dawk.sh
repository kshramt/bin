#!/bin/bash

# set -xv
set -o nounset
set -o errexit
set -o pipefail
set -o noclobber

usage_and_exit(){
   {
      echo '# double precision AWK'
      echo $(basename "${0}")
   } > /dev/stderr
   exit 1
}

"${MY_AWK:-gawk}" -v OFS=$'\t' -v CONVFMT='%.15g' -v OFMT='%.15g' "$@"
