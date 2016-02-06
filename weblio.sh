#!/bin/bash

IFS=$' \t\n'

# set -xv
set -o nounset
set -o errexit
set -o pipefail
set -o noclobber

"${0%/*}"/open_uri.sh 'http://ejje.weblio.jp/sentence/content/' "$@"
