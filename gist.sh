#!/bin/bash

# set -xv
set -o nounset
set -o errexit
set -o pipefail
set -o noclobber

readonly GIST_DIR="${HOME}/d/prog/gist"

usage_and_exit(){
   {
      echo "# Commit files to a git repository, ${GIST_DIR}"
      echo "$0" FILE1 FILE2 ...
   } > /dev/stderr

    exit ${1:-1}
}

if [[ $# -eq 0 ]] || [[ "$1" = "-h" ]] || [[ "$1" = "--help" ]]; then
   usage_and_exit 1
fi

mkdir -p "${GIST_DIR}"
if [[ -a "${GIST_DIR}/.git" ]]; then
   :
else
   pushd "${GIST_DIR}"
   git init
   git commit --allow-empty -m "Empty"
   popd
fi

for f in "$@"
do
   \cp -a -i "${f}" "${GIST_DIR}/$(basename ${f})"
done

pushd "${GIST_DIR}"
git add *
git commit -am "Update"
popd
