#!/bin/bash

IFS=$' \t\n'

# set -xv
set -o nounset
set -o errexit
set -o pipefail
set -o noclobber

source "${0%/*}"/util.sh

ret="$(parse_stem.sh days@60!n_iter@1024!is_logs@t,t,t,f,f)"
expected='days="60"
n_iter="1024"
is_logs="t,t,t,f,f"'
[[ "${ret}" = "${expected}" ]]

ret="$(parse_stem.sh days@60!n_iter@1024!is_logs@t,t,t,f,f 'declare -rx')"
expected='declare -rx days="60"
declare -rx n_iter="1024"
declare -rx is_logs="t,t,t,f,f"'
[[ "${ret}" = "${expected}" ]]
