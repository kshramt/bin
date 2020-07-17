#!/bin/bash

set -o nounset
set -o errexit

readonly emacsclient_="${MY_EMACSCLIENT:-emacsclient}"
if "${emacsclient_}" -e '()' > /dev/null 2>&1 ; then
    "${emacsclient_}" -e '(kill-emacs)'
fi
