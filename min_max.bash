#!/bin/bash

set -o nounset
set -o errexit
set -o pipefail

tmp_dir=$(mktemp --directory)

finalize(){
    rm -fr ${tmp_dir}
}

trap finalize EXIT

copy_file=${tmp_dir}/copy_file.dat
cat > ${copy_file}
x_sorted=${tmp_dir}/x_sorted.dat
y_sorted=${tmp_dir}/y_sorted.dat
sort -n -k 1 ${copy_file} > ${x_sorted}
sort -n -k 2 ${copy_file} > ${y_sorted}
x1=$(head -1 ${x_sorted}| awk '{print $1}')
y1=$(head -1 ${y_sorted}| awk '{print $2}')
x2=$(tail -1 ${x_sorted}| awk '{print $1}')
y2=$(tail -1 ${y_sorted}| awk '{print $2}')

echo -e "${x1}\t${x2}\t${y1}\t${y2}"
