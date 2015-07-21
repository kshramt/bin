#!/bin/bash

IFS=$' \t\n'
umask u=rwx,g=,o=


# set -xv
set -o nounset
set -o errexit
set -o pipefail
set -o noclobber

usage_and_exit(){
   {
      echo "${0##*/}" 'days@60!n_iter@1024!is_logs@t,t,t,f,f'
      echo "${0##*/}" 'days@60!n_iter@1024!is_logs@t,t,t,f,f' "'declare -rx'"
   } >&2
   exit "${1:-1}"
}

if [[ $# -eq 1 ]]; then
   if [[ "$1" = -h ]] || [[ "$1" = --help ]]; then
      usage_and_exit 0
   fi
   stem="$1"
   decl=''
elif [[ $# -eq 2 ]]; then
   stem="$1"
   decl="$2"
else
   usage_and_exit 1
fi

if [[ -z "$decl" ]]; then
   while read l
   do
      echo "$l"'"'
   done
else
   while read l
   do
      echo "$decl" "$l"'"'
   done
fi < <(
   echo "$stem" |
      sed -e 's/@/="/g' -e 's/!/\n/g'
)
