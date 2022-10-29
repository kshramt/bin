#!/bin/bash

# set -xv
set -o nounset
set -o errexit
set -o pipefail
set -o noclobber

readonly dir="${0%/*}"
"${dir}"/reduce.sh 0 'ret += $1'
