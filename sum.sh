#!/bin/bash

# set -xv
set -o nounset
set -o errexit
set -o pipefail
set -o noclobber

usage_and_exit(){
   {
      echo $(basename "$0") 
   } > /dev/stderr
   exit 1
}

flatten.sh |
dawk.sh '
BEGIN{
   sum = 0
}
{
   sum += $i
}
END{
   print(sum)
}
'
