#!/bin/bash

# set -xv
set -o nounset
set -o errexit
set -o pipefail
set -o noclobber

export IFS=$' \t\n'
export LANG=en_US.UTF-8
umask u=rwx,g=,o=


readonly t="$(date +'%y%m%d%H%M%S')"
readonly cmd="$1"
readonly suffix="${2:-png}"

mkdir -p gp.sh.d
readonly src="set term ${suffix}; ${cmd}"
echo "${src}" > "gp.sh.d/${t}.plt"
gnuplot -e "${src}" > "gp.sh.d/${t}.${suffix}"
"${MY_OPEN:-xdg-open}" "gp.sh.d/${t}.${suffix}"
