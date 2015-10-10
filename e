#!/bin/bash

set -o nounset
set -o errexit
set -o pipefail

if [[ $(uname) = Darwin ]]; then
   for file in "$@"
   do
      if [[ ! -e "$file" ]]; then
         mkdir -p "$(dirname "$file")"
         touch "$file"
      fi
   done
   open -a emacs "$@"
else
   "${0%/*}"/e.sh --mode=gui "$@"
fi
