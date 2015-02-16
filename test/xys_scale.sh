#!/bin/bash

IFS=$' \t\n'

# set -xv
set -o nounset
set -o errexit
set -o pipefail
set -o noclobber

source "$(dirname "${0}")"/util.sh

readonly ret="$(cat <<EOF | "$target"
1 1
2 -1
3 2
4 -2
EOF
)"
readonly expected="1	0.5
2	-0.5
3	1
4	-1"

[[ "$ret" = "$expected" ]]
