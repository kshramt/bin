#!/bin/bash

set -o nounset
set -o errexit
set -o pipefail

${MY_RUBY:-ruby} "${0%.*}" "${@}"
