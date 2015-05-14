#!/bin/bash

IFS=$' \t\n'

# set -xv
set -o nounset
set -o errexit
set -o pipefail
set -o noclobber

source "${0%/*}"/util.sh

readonly ret="$(cat <<EOF | "$target" 2 3
1 10
2 20
3 15
4 30
EOF
)"
readonly expected="2	20
3	15"

[[ "$ret" = "$expected" ]]
