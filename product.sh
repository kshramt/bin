#!/bin/bash

# set -xv
set -o nounset
set -o errexit
set -o pipefail
set -o noclobber

{
   i=0
   for xs in "$@"
   do
      echo "for x$((i++)) in $(sed -e 's/,/\t/g' <<<$xs); do"
   done

   if [[ $# -gt 0 ]]; then
      echo -n 'echo "'
      i=0
      for _ in "$@"
      do
         if [[ "$i" -gt 0 ]]; then
            echo -ne '\t$x'"$((i++))"
         else
            echo -ne '$x'"$((i++))"
         fi
      done
      echo -n '"'
      echo
   fi

   yes 'done' | head -n $#
} | bash
