#!/bin/bash

IFS=$' \t\n'

# set -xv
set -o nounset
set -o errexit
set -o pipefail
set -o noclobber


"${0%/*}"/mirror.sh --no-check-certificate "$@"
