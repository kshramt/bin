#!/bin/bash

IFS=$' \t\n'

# set -xv
set -o nounset
set -o errexit
set -o pipefail
set -o noclobber

source "${0%/*}"/util.sh

[[ "$(echo 1 1 | "${target}")" = "" ]]
[[ "$({ echo 1 1 ; echo 1.5 3 ; } | "${target}")" = "1.25	4" ]]
[[ "$({ echo 1 1 ; echo 1.5 3 ; echo 2.5 -1 ; } | "${target}")" = $'1.25\t4\n2\t-4' ]]
