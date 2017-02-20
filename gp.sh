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

gnuplot -e "set term $suffix; $cmd" > "gp.sh.$t.$suffix"
"${MY_OPEN:-xdg-open}" "gp.sh.$t.$suffix" &

mkdir -p "$HOME"/d/log/gp.sh
cp -f "gp.sh.$t.$suffix" "$HOME"/d/log/gp.sh/
{
   echo "# invoked from $(pwd)"
   echo "$cmd"
} > "$HOME"/d/log/gp.sh/"gp.sh.$t.$suffix".plt
