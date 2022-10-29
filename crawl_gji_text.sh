#!/bin/bash

set -xv
set -o nounset
#set -o errexit
set -o pipefail
set -o noclobber

export IFS=$' \t\n'
export LANG=en_US.UTF-8
umask u=rwx,g=,o=


dir="${1:-gji_dump}"
mkdir -p "${dir}"
for year in {1999..2016}
do
   curl --silent http://gji.oxfordjournals.org/content/by/year/"${year}" |
      grep page-range |
      ruby -e 'puts $stdin.read.scan(/href="([^"]*)"/)' |
      while read toc
      do
         curl --silent --location http://gji.oxfordjournals.org"${toc}" |
            grep 'Full Text (HTML)' |
            ruby -e 'puts $stdin.read.scan(/href="([^"]*)"/)' |
            while read cont
            do
               f="${dir}/${cont}"
               if [[ ! -s "${f}" ]]; then
                  mkdir -p "$(dirname "${f}")"
                  w3m -cols 100000000 -dump http://gji.oxfordjournals.org"${cont}" >| "${f}"
                  sleep 10
               fi
            done
      done
done
