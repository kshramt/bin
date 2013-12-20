#!/bin/bash

# set -xv
set -o nounset
set -o errexit
set -o pipefail
set -o noclobber

usage_and_exit(){
   echo $(basename "${0}") "[DIR:-.] | tail -n +2 | plot_commits.py.sh >| commits.pdf"
   exit 1
}

if [[ $# -ne 0 ]]; then
   usage_and_exit
fi

cd ${1:-.}

echo $'time\taddition\tdeletion\ttotal'
git log \
   --numstat \
   --pretty=tformat:'TIME %ai' \
   --reverse \
   | gawk '
BEGIN{
   addition = 0; deletion = 0; total = 0; OFS="\t"
}
$1 == "TIME"{
   time_ = $2 "T" $3 $4
}
NF==3 && $1 != "-" && $2 != "-" {
   addition += $1
   deletion += $2
   total += $1 - $2
}
NF==0{
   print time_, addition, deletion, total
}
END{
   print time_, addition, deletion, total
}
' \
   | sort -k1
