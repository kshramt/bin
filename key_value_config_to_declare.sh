#!/bin/bash

set -o nounset
set -o errexit
set -o pipefail

strip.sh "$@" \
   | uncomment.sh \
   | sed -e '
     /^$/d
     s/[ \t]\+/="/
     s/$/"/'
