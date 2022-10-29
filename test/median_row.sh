#!/bin/bash

IFS=$' \t\n'

# set -xv
set -o nounset
set -o errexit
set -o pipefail
set -o noclobber

source "${0%/*}"/util.sh

if echo | "${target}"; then
   false
fi
[[ "$(echo -1 1 | "${target}")" = 0 ]]
[[ "$(echo 1 -1 | "${target}")" = 0 ]]
[[ "$(echo 1 -1 2 | "${target}")" = 1 ]]
[[ "$(echo 1 2 -1 | "${target}")" = 1 ]]
