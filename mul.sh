#!/bin/bash

# set -xv
set -o nounset
set -o errexit
set -o pipefail
set -o noclobber

flatten.sh | reduce.sh 1 'ret *= $1'
