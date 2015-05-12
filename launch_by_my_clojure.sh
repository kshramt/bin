#!/bin/bash

set -o nounset
set -o errexit
set -o pipefail
set -o noclobber

java -cp ${MY_CLOJURE:-$(dirname "$0")/clojure.jar} clojure.main "${0%.*}" "$@"
