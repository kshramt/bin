#!/bin/bash

IFS=$' \t\n'

# set -xv
set -o nounset
set -o errexit
set -o pipefail
set -o noclobber

readonly dir="${0%/*}"


"${dir}"/dawk.sh '
NR == 1{
   print $1, 0
   print $1, $6
   print $2, $6
}
NR != 1 {
   print $1, $6
   print $2, $6
   xlast = $2
}
END{
   print xlast, 0
}'
