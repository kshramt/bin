#!/bin/bash

set -o nounset
set -o errexit
set -o pipefail

if [[ ${#} -eq 0 ]]; then
    echo "${0}" FILES DIRS 1>&2
    exit 1
fi

my_trash_dir=${MY_TRASH_DIR:-${HOME}/.Trash/tsh.sh}
dir=${my_trash_dir}/$(date +'%FT%T.%N%z')
mkdir -p ${dir}

mv -- "${@}" "${dir}"
