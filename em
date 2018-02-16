#!/bin/sh

set -o nounset
set -o errexit

"${0%/*}"/e.sh cui "$@"
