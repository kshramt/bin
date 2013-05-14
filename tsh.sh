#!/bin/sh

if [ ${#} -eq 0 ]; then
    echo "${0}" FILES DIRS
    exit 0
fi

my_trash_dir=${MY_TRASH_DIR:-${HOME}/.Trash/tsh.sh}
dir=${my_trash_dir}/$(date +'%FT%T.%N%z')
mkdir -p ${dir}

mv -- "${@}" "${dir}"
