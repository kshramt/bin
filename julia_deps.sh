#!/bin/bash

# set -xv
set -o nounset
set -o errexit
set -o pipefail
set -o noclobber

usage_and_exit(){
   echo "$(basename ${0}) | rake_p_to_dot.sh | dot -Tpdf >| _.pdf"
   exit 1
}

if [[ $# -ne 0 ]]; then
   usage_and_exit
fi

\cd "${HOME}"/.julia/METADATA/
for package in *
do
   echo "rake ${package}"
   dir="${package}/versions"
   if [[ -d "${dir}" ]]; then
      version=$(ls -1 "${dir}" | tail -1)
      file="${package}/versions/${version}/requires"
      if [[ -r "${file}" ]]; then
         cat "${file}" \
            | (grep -v '^\(@\|#\|julia\)' || echo '') \
            | gawk 'NF >= 1{print "  " $1}'
      fi
   fi
done
