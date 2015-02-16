#!/bin/bash

IFS=$' \t\n'

# set -xv
set -o nounset
set -o errexit
set -o pipefail
set -o noclobber

source "$(dirname "${0}")"/util.sh

readonly ret="$(seq 5 | "$target" 0 1)"
readonly expected="0	1
1	2
2	3
3	4
4	5"
[[ "$ret" = "$expected" ]]
