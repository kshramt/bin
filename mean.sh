#!/bin/bash

IFS=$' \t\n'

# set -xv
set -o nounset
set -o errexit
set -o pipefail
set -o noclobber

readonly dir="${0%/*}"
"$dir"/dawk.sh '
BEGIN{sum = 0}
{sum += $1}
END{print sum/NR}'
