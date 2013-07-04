#!/bin/bash

set -o nounset
set -o errexit
set -o pipefail
set -o noclobber

${MY_RUBY:-ruby} -e "puts ""$@"
