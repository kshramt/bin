#!/bin/bash

IFS=$' \t\n'

# set -xv
set -o nounset
set -o errexit
set -o pipefail
set -o noclobber

${MY_OPEN:-gnome-open} 'http://ejje.weblio.jp/sentence/content/'"$(echo -n "$@" | "${0%/*}"/encode_uri.sh)"
