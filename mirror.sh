#!/bin/bash

IFS=$' \t\n'

# set -xv
set -o nounset
set -o errexit
set -o pipefail
set -o noclobber


mkdir -p "${root:="${HOME}/d/mirror"}"
cd "${root}"
wget -w 1.1 -r -S -N -np -p -k -nc --user-agent="Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:11.0) Gecko/20100101 Firefox/11.0" "$@"
