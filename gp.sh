#!/bin/bash

# set -xv
set -o nounset
set -o errexit
set -o pipefail
set -o noclobber

export IFS=$' \t\n'
export LANG=en_US.UTF-8
umask u=rwx,g=,o=


readonly t="$(date +%s)"
readonly cmd="$1"
readonly suffix="${2:-png}"

mkdir -p gp.sh.d
gnuplot -e "set term $suffix; $cmd" > "gp.sh.d/$t.$suffix"
"${MY_OPEN:-xdg-open}" "gp.sh.d/$t.$suffix"
