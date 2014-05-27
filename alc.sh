#!/bin/bash

IFS=$' \t\n'

# set -xv
set -o nounset
set -o errexit
set -o pipefail
set -o noclobber

"${MY_OPEN:-gnome-open}" 'http://eow.alc.co.jp/search?q='"$(echo -n "$@" | "$(dirname "$0")"/encode_uri.sh)"
