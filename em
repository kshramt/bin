#!/bin/bash

set -o nounset
set -o errexit
set -o pipefail

if [[ $(uname) = Darwin ]]; then
   open -a emacs "$@"
else
   "${0%/*}"/e.sh --mode=cui "$@"
fi
