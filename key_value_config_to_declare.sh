#!/bin/bash

set -o nounset
set -o errexit
set -o pipefail

readonly THIS_DIR="${0%/*}"
"${THIS_DIR}"/strip.sh "$@" \
   | "${THIS_DIR}"/uncomment.sh \
   | sed -e '
     /^$/d
     s/[ \t]\+/="/
     s/$/"/'
