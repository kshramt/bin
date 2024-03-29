#!/bin/bash

set -o nounset
set -o errexit
set -o pipefail

if [[ ! -x "${1}" ]]; then
    echo FILE_NOT_EXIST: "${1}" 1>&2
    exit 1
fi

if [[ -n "$@" ]]; then
    echo FAIL: "${1}" 1>&2
    exit 1
else
    echo . SUCCESS: "${1}"
    exit 0
fi
