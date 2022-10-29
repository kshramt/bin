#!/bin/bash

IFS=$' \t\n'

# set -xv
set -o nounset
set -o errexit
set -o pipefail
set -o noclobber

source "${0%/*}"/util.sh

ret="$("${target}" "p q" "$(seq -s\  3)" "{a..c}")"
expected="p	1	a
p	1	b
p	1	c
p	2	a
p	2	b
p	2	c
p	3	a
p	3	b
p	3	c
q	1	a
q	1	b
q	1	c
q	2	a
q	2	b
q	2	c
q	3	a
q	3	b
q	3	c"

[[ "${ret}" = "${expected}" ]]
