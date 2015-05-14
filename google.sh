#!/bin/bash

IFS=$' \t\n'

# set -xv
set -o nounset
set -o errexit
set -o pipefail
set -o noclobber

${MY_OPEN:-gnome-open} 'https://www.google.com/search?q='"$(echo -n "$@" | "${0%/*}"/encode_uri.sh)"
