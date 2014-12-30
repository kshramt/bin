#!/bin/bash

IFS=$' \t\n'

# set -xv
set -o nounset
set -o errexit
set -o pipefail
set -o noclobber

readonly dir="$(pwd)"
curl -s http://www.data.jma.go.jp/svd/eqev/data/bulletin/hypo.html |
"${MY_RUBY:-ruby}" -e 'puts STDIN.read.scan(/a href="?([^"]+?\.zip)/)' |
while read uri
do
   wget -q --timestamping http://www.data.jma.go.jp/svd/eqev/data/bulletin/"$uri"
   echo "$dir"/"$(basename "$uri")"
   sleep 1
done
