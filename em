#!/bin/bash

set -o nounset
set -o errexit
set -o pipefail

if [[ $(uname) = Darwin ]]; then
   open -a emacs "$@"
else
   "$(dirname "${0}")"/e.sh --mode=cui "$@"
fi
