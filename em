#!/bin/bash

set -o nounset
set -o errexit
set -o pipefail

if [[ $(uname) = Darwin ]]; then
   i=0
   for file in "$@"
   do
      if [[ ! -e "$file" ]]; then
         {
            mkdir -p "$(dirname "$file")"
            touch "$file"
         } &
         i="$((i + 1))"
      fi
      if [[ i -ge 20 ]]; then
         wait
         i=0
      fi
   done
   wait
   open -a emacs "$@"
else
   "${0%/*}"/e.sh --mode=cui "$@"
fi
