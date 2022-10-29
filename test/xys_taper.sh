#!/bin/bash

IFS=$' \t\n'

# set -xv
set -o nounset
set -o errexit
set -o pipefail
set -o noclobber

source "${0%/*}"/util.sh

readonly ret="$(paste <(seq 0 10) <(yes 1 | head -n11) | "${target}" cos 0.25)"
readonly expected="0	0
1	0.345491502812526
2	0.904508497187474
3	1
4	1
5	1
6	1
7	1
8	0.904508497187474
9	0.345491502812526
10	0"

[[ "${ret}" = "${expected}" ]]
