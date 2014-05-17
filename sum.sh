#!/bin/bash

# set -xv
set -o nounset
set -o errexit
set -o pipefail
set -o noclobber

readonly THIS_DIR="$(dirname "$0")"
"${THIS_DIR}"/flatten.sh | "${THIS_DIR}"/reduce.sh 0 'ret += $1'
