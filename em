#!/bin/sh

set -o nounset
set -o errexit
set -o pipefail

$(dirname "${0}")/e.sh --mode=cui "$@"
