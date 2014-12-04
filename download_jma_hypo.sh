#!/bin/bash

IFS=$' \t\n'

# set -xv
set -o nounset
set -o errexit
set -o pipefail
set -o noclobber


curl -s http://www.data.jma.go.jp/svd/eqev/data/bulletin/hypo.html |
ruby -e 'puts STDIN.read.scan(/a href="?([^"]+?\.zip)/)' |
while read uri
do
   wget --timestamping http://www.data.jma.go.jp/svd/eqev/data/bulletin/"$uri"
   sleep 1
done
