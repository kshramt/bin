#!/bin/bash

set -o nounset
set -o errexit
set -o pipefail

if [[ ${#} -eq 0 ]]; then
    echo "${0}" FILES DIRS
    exit 1
fi

my_backup_dir=${MY_BACKUP_DIR:-${HOME}/backup}
root_dir=${my_backup_dir}/"$(date +'%FT%T.%N%z')"

for f in "${@}"
do
    full_path=$(readlink -f "${f}")
    dir="${root_dir}"/$(dirname "${full_path}")
    mkdir -p "${dir}"
    if [[ -e "${f}" ]]; then
        cp -a "${full_path}" "${dir}"
        echo "${f}"
    fi
done

echo
echo ROOT_DIR: "${root_dir}"
