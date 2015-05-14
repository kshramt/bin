#!/bin/bash

set -o nounset
set -o errexit
set -o pipefail

exec ${MY_PYTHON:-python} "${0%.*}" "$@"
