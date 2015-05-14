#!/bin/bash

# set -xv
set -o nounset
set -o errexit
set -o pipefail
set -o noclobber

readonly THIS_DIR="${0%/*}"
"${THIS_DIR}"/flatten.sh | "${THIS_DIR}"/reduce.sh 1 'ret *= $1'
