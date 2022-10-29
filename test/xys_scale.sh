#!/bin/bash

IFS=$' \t\n'

# set -xv
set -o nounset
set -o errexit
set -o pipefail
set -o noclobber

source "${0%/*}"/util.sh

ret="$(cat <<EOF | "${target}" -inf inf
1 1
2 -1
3 2
4 -2
EOF
)"
expected="1	0.5
2	-0.5
3	1
4	-1"

[[ "${ret}" = "${expected}" ]]


ret="$(cat <<EOF | "${target}" 3 3.1
1 1
2 -1
3 2
4 -2
EOF
)"
expected="1	0.5
2	-0.5
3	1
4	-1"

[[ "${ret}" = "${expected}" ]]


ret="$(cat <<EOF | "${target}" 3.9 4
1 1
2 -1
3 2
4 -2
EOF
)"
expected="1	0.5
2	-0.5
3	1
4	-1"

[[ "${ret}" = "${expected}" ]]


ret="$(cat <<EOF | "${target}" 1.5 2.5
1 1
2 -1
3 2
4 -2
EOF
)"
expected="1	1
2	-1
3	2
4	-2"

[[ "${ret}" = "${expected}" ]]
