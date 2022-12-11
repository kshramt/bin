#!/bin/bash

IFS=$' \t\n'

# set -xv
set -o nounset
set -o errexit
set -o pipefail
set -o noclobber

usage_and_exit(){
   {
      echo "# large <scale> means whiter colors"
      echo "${0##*/}" '<scale> < globe.cpt'
   } >&2
   exit "${1}"
}


if [[ $# -ne 1 ]] || [[ $1 = -h ]] || [[ $1 = --help ]]; then
   usage_and_exit 1
fi


readonly dir="${0%/*}"
readonly scale="$1"

while read -r line
do
   if [[ "${line}" =~ [A-Za-z] ]]; then
      echo "${line}"
   else
      if [[ "${line}" =~ / ]]; then
         echo "${line}" | while read -r a1 rgb1 a2 rgb2 # a: altitude
                        do
                           r1="$(echo "${rgb1}" | cut -f1 -d/)"
                           g1="$(echo "${rgb1}" | cut -f2 -d/)"
                           b1="$(echo "${rgb1}" | cut -f3 -d/)"
                           hsv1="$("${dir}"/hsv_from_rgb.rb.sh "${r1}" "${g1}" "${b1}")"
                           h1="$(echo "${hsv1}" | cut -f1 -d' ')"
                           s1="$(echo "${hsv1}" | cut -f2 -d' ' | gawk -v scale="${scale}" '{print $1/scale}')"
                           v1="$(echo "${hsv1}" | cut -f3 -d' ' | gawk -v scale="${scale}" '{print 1 - (1 - $1)/scale}')"
                           r2="$(echo "${rgb2}" | cut -f1 -d/)"
                           g2="$(echo "${rgb2}" | cut -f2 -d/)"
                           b2="$(echo "${rgb2}" | cut -f3 -d/)"
                           hsv2="$("${dir}"/hsv_from_rgb.rb.sh "${r2}" "${g2}" "${b2}")"
                           h2="$(echo "${hsv2}" | cut -f1 -d' ')"
                           s2="$(echo "${hsv2}" | cut -f2 -d' ' | gawk -v scale="${scale}" '{print $1/scale}')"
                           v2="$(echo "${hsv2}" | cut -f3 -d' ' | gawk -v scale="${scale}" '{print 1 - (1 - $1)/scale}')"
                           echo "${a1}" "${h1}"-"${s1}"-"${v1}" "${a2}" "${h2}"-"${s2}"-"${v2}"
                        done
      else
         echo "${line}"
      fi
   fi
done
