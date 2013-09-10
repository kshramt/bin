#!/bin/bash

set -o nounset
set -o errexit
set -o pipefail

grep '^ *use, non_intrinsic::' "${1:--}" \
    | awk '{print $3}' \
    | sed -e 's/,$//' \
    | sort -u
