#!/bin/bash

set -o nounset
set -o errexit
set -o pipefail

if [[ $(uname) = Darwin ]]; then
   for f in "$@"
   do
      if [[ ! -f $f ]]; then
         mkdir -p $(dirname "${f}")
         touch "${f}"
      fi
   done
   open -a emacs "$@"
else
   "${0%/*}"/e.sh --mode=gui "$@"
fi
