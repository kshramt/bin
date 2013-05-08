#!/bin/sh

set -o nounset
set -o errexit
set -o pipefail

sed -e '/^ *#/d' "$@"
