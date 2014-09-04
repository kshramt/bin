#!/bin/bash

IFS=$' \t\n'

# set -xv
set -o nounset
set -o errexit
set -o pipefail
set -o noclobber


readonly BASE_URI=http://dds.cr.usgs.gov/srtm/version2_1/SRTM3/

for d in $(curl "${BASE_URI}" | grep '<li><a' | grep -v 'Parent Directory' | sed -e 's|<li><a href="||g' -e 's|">.*||g')
do
   for f in $(curl "${BASE_URI}""${d}"/ | grep '<li><a' | grep -v 'Parent Directory' | sed -e 's|<li><a href="||g' -e 's|">.*||g')
   do
      echo "${BASE_URI}""${d}""${f}"
   done
done
