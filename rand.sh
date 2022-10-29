#!/bin/bash

# set -xv
set -o nounset
set -o errexit
set -o pipefail
set -o noclobber

usage_and_exit(){
   {
      echo '# generate uniform random numbers [0, 1)'
      echo "${0##*/}" '[SEED]'
   } > /dev/stderr
   exit "${1}"
}

opts=$(
   getopt \
      --unquoted \
      --options h \
      --longoptions help \
      -- \
      "$@"
)
set -- "${opts}"

while true
do
   case "$1" in
      -h | --help)
         usage_and_exit 1
         ;;
      --)
         shift
         break
         ;;
   esac
done

if [[ $# -eq 0 ]]; then
   readonly SRAND='srand()'
else
   readonly SRAND="srand($1)"
fi

"${0%/*}"/dawk.sh "
BEGIN{
   ${SRAND}
   while(1){
      print(rand())
   }
}
" || :
