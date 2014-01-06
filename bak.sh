#!/bin/bash

set -o nounset
set -o errexit
set -o pipefail

if [[ ${#} -eq 0 ]]; then
    echo "${0}" FILES DIRS 1>&2
    exit 1
fi

my_backup_dir=${MY_BACKUP_DIR:-${HOME}/d/backup}
root_dir=${my_backup_dir}/"$(date +'%FT%T.%N%z')"
exit_status=0

for f in "$@"
do
    full_path=$(readlink -f -- "${f}")
    dir="${root_dir}"/$(dirname -- "${full_path}")
    mkdir -p -- "${dir}"
    if [[ -e "${full_path}" ]]; then
        if [[ ! -e "${root_dir}/${full_path}" ]]; then
            cp -a -- "${full_path}" "${dir}"
        fi
    else
        exit_status=1
        echo FAIL: "${f}" 1>&2
    fi
done

exit ${exit_status}
