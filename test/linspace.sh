#!/bin/bash

IFS=$' \t\n'

# set -xv
set -o nounset
set -o errexit
set -o pipefail
set -o noclobber

source "${0%/*}"/util.sh

readonly ret="$("${target}" 0 1 11)"
readonly expected="0
0.1
0.2
0.3
0.4
0.5
0.6
0.7
0.8
0.9
1"

[[ "${ret}" = "${expected}" ]]
