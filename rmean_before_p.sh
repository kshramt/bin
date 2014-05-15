#!/bin/bash

IFS=$' \t\n'

# set -xv
set -o nounset
set -o errexit
set -o pipefail
set -o noclobber

usage_and_exit(){
   {
      echo 'remove mean before P-arrival'
      echo "$(basename "$0")" IN_FILE OUT_FILE
   } > /dev/stderr
   exit 1
}

readonly TMP_DIR="$(mktemp -d)"

finalize(){
   rm -fr "${TMP_DIR}"
}

trap finalize EXIT

if [[ $# -ne 2 ]]; then
   usage_and_exit
fi

readonly IN_FILE="$1"
readonly OUT_FILE="$2"

readonly RMEAN_BEFORE_P_MACRO="${TMP_DIR}"/rmean_before_p.m

cat <<EOF >| "${RMEAN_BEFORE_P_MACRO}"
cut b a
r ${IN_FILE}
int
setbb abs_depmin (abs &1,depmin)
if %abs_depmin ge &1,depmax
   setbb sum_before_p &1,depmin
else
   setbb sum_before_p &1,depmax
endif
setbb mean_before_p (%sum_before_p / (&1,a - &1,b))
cut off
r ${IN_FILE}
sub %mean_before_p
w ${OUT_FILE}
EOF


SAC_DISPLAY_COPYRIGHT=false sac <<EOF
macro ${RMEAN_BEFORE_P_MACRO}
quit
EOF
