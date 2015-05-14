#!/bin/bash

set -o nounset
set -o errexit
set -o pipefail
set -o noclobber

exec java -cp ${MY_CLOJURE:-${0%/*}/clojure.jar} clojure.main "${0%.*}" "$@"
