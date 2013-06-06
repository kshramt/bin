#!/bin/bash

set -o nounset
set -o errexit
set -o pipefail

${MY_PYTHON:-python} "${0%.*}" "${@}"
