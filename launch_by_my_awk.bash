#!/bin/bash

set -o nounset
set -o errexit
set -o pipefail

${MY_AWK:-gawk} -f "${0%.*}" "$@"
