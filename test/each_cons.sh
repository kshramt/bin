#!/bin/bash

IFS=$' \t\n'

# set -xv
set -o nounset
set -o errexit
set -o pipefail
set -o noclobber

source "${0%/*}"/util.sh

readonly ret="$(seq 10 | "${target}" 3)"
readonly expected="1	2	3
2	3	4
3	4	5
4	5	6
5	6	7
6	7	8
7	8	9
8	9	10"

[[ "${ret}" = "${expected}" ]]
