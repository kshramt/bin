#!/bin/bash

IFS=$' \t\n'

# set -xv
set -o nounset
set -o errexit
set -o pipefail
set -o noclobber

source "$(dirname "${0}")"/util.sh

[[ "$(echo 0 0 | "$target")" = "" ]]
[[ "$({ echo 0 0 ; echo 0.5 2 ; } | "$target")" = "0.25	4" ]]
[[ "$({ echo 0 0 ; echo 0.5 2 ; echo 1.5 -1 ; } | "$target")" = $'0.25\t4\n1\t-3' ]]
