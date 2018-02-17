#!/bin/sh

# set -xv
set -o nounset
set -o errexit
set -o noclobber

export IFS=$' \t\n'
export LANG=en_US.UTF-8
umask u=rwx,g=,o=


readonly command="$1"
shift
for f in "$@"
do
   "$command" "$f"
done
