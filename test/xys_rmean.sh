#!/bin/bash

IFS=$' \t\n'

# set -xv
set -o nounset
set -o errexit
set -o pipefail
set -o noclobber

source "${0%/*}"/util.sh

readonly ret="$(cat <<EOF | "$target" -inf 2.5
1 10
2 20
3 15
4 30
EOF
)"
readonly expected="1	-5
2	5
3	0
4	15"

[[ "$ret" = "$expected" ]]
