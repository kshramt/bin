#!/bin/bash

set -o nounset
set -o errexit
set -o pipefail

readonly PROGRAM_NAME=$(basename $0)

usage_and_exit(){
   cat <<EOF > /dev/stderr
${PROGRAM_NAME} N < FILE
# Drop first N lines of input.
EOF

   exit 1
}

if [[ $# -ne 1 ]]; then
   usage_and_exit
fi

if [[ $1 = '-h' ]] || [[ $1 = '--help' ]]; then
   usage_and_exit
fi

awk 'NR > '$1' {print $0}'
