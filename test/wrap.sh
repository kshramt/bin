#!/bin/bash

IFS=$' \t\n'

# set -xv
set -o nounset
set -o errexit
set -o pipefail
set -o noclobber

source "$(dirname "${0}")"/util.sh

ret="$(seq 10 | "$target" 5; printf x)"
expected="1	2	3	4	5
6	7	8	9	10
x"

[[ "$ret" = "$expected" ]]

ret="$(seq 7 | "$target" 5; printf x)"
expected="1	2	3	4	5
6	7
x"

[[ "$ret" = "$expected" ]]
