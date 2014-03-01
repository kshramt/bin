#!/bin/bash

# set -xv
set -o nounset
set -o errexit
set -o pipefail
set -o noclobber

usage_and_exit(){
   {
      echo '# Extract a header field value from a binary sac file.'
      echo '# Nothing is printed if the field is not defined or exist.'
      echo $(basename "${0}") FILE FIELD
   } > /dev/stderr
   exit 1
}

if [[ $# -ne 2 ]]; then
   usage_and_exit
fi

SAC="${MY_SAC:-sac}"

file="$1"
field="$2"

"${SAC}" <<EOF | grep = | awk '{print $3}'
read ${file}
listhdr ${field}
quit
EOF
