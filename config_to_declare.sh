#!/bin/bash
#
# Convert a key-value style configuration file to Bash's readonly variable declarations.

set -o nounset
set -o errexit
set -o pipefail

strip.sh "$@" \
   | uncomment.sh \
   | sed -e '
     /^$/d
     s/[ \t]\+/=/
     s/^/declare -xr /'
