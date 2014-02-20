#!/bin/bash

# set -xv
set -o nounset
set -o errexit
set -o pipefail
set -o noclobber

(
   i=0
   for xs in "$@"
   do
      echo "for x$((i++)) in $(echo "$xs" | sed -e 's/,/\t/g'); do"
   done

   if [[ $# -gt 0 ]]; then
      echo -n 'echo "'
      i=0
      for _ in "$@"
      do
         if [[ "$i" -gt 0 ]]; then
            echo -n $'\t$x'"$((i++))"
         else
            echo -n $'$x'"$((i++))"
         fi
      done
      echo -n '"'
      echo
   fi

   for _ in "$@"
   do
      echo 'done'
   done
) | bash
