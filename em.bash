#!/bin/bash

set -o nounset
set -o errexit
set -o pipefail

source $(dirname "${0}")/launch_emacs_daemon.bash

${emacsclient_} -t -- "$@"
