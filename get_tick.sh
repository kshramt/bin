#!/bin/zsh

# set -xv
set -o nounset
set -o errexit
set -o pipefail
set -o noclobber

export IFS=$' \t\n'
export LANG=en_US.UTF-8
umask u=rwx,g=,o=


usage_and_exit(){
   {
      echo "${0##*/}" '<x1> <x2> [<padding>]'
   } >&2
   exit "${1:-1}"
}


if [[ $# -eq 2 ]]; then
   readonly padding=0.1
elif [[ $# -eq 3 ]]; then
   readonly padding="$3"
else
   usage_and_exit
fi
[[ "$padding" -ge 0 ]]

readonly x1="$1"
readonly x2="$2"
readonly lx="$((x2 - x1))"
[[ "$lx" -ge 0 ]]


zmodload zsh/mathfunc


readonly _dx="$((10**(ceil(log10(lx)) - 1)))"
if [[ "$lx" -gt "$((5*_dx))" ]]; then
   readonly dx="$_dx"
elif [[ "$lx" -gt "$((2*_dx))" ]]; then
   readonly dx="$((5*_dx/10))"
else
   readonly dx="$((2*_dx/10))"
fi
[[ "$dx" -ge 0 ]]


readonly _lower="$((floor(x1/dx)*dx))"
if [[ "$x1" -le "$((_lower + dx*padding))" ]]; then
   readonly lower="$((_lower - dx))"
else
   readonly lower="$_lower"
fi


readonly _upper="$((ceil(x2/dx)*dx))"
if [[ "$x2" -ge "$((_upper - dx*padding))" ]]; then
   readonly upper="$((_upper + dx))"
else
   readonly upper="$_upper"
fi


echo "$lower	$upper	$dx"
