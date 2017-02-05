#!/bin/bash

set -o nounset
set -o errexit
set -o pipefail

"${0%/*}"/e.sh --mode=cui "$@"
