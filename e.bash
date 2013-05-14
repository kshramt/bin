#!/bin/bash

set -o nounset
set -o errexit
set -o pipefail

source $(dirname "${0}")/launch_emacs_daemon.bash

is_gui_running(){
    local emacsclient_="${1}"
    [ "$(${emacsclient_} -e '(window-system)')" = "x" ]
}

if is_gui_running ${emacsclient_}; then
    ${emacsclient_} -n -- "$@"
else
    ${emacsclient_} -c -n -- "$@"

    # Run within terminal when X is not supported.
    if is_gui_running ${emacsclient_}; then
        :
    else
        em.bash "$@"
    fi
fi
