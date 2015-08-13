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
      echo -n "for x$((i++)) in "
      echo "$xs"
      echo "do"
   done

   if [[ $# -gt 0 ]]; then
      echo -n 'echo "$x0'
      for (( i=1; i<$#; i++ ))
      do
         if [[ "$i" -gt 0 ]]; then
            echo -ne '\t$x'"$i"
         fi
      done
      echo -n '"'
      echo
   fi

   { yes 'done' || : ; } | head -n $#
} | bash
