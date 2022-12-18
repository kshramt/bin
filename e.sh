#!/bin/bash

# set -xv
set -o nounset
set -o errexit

usage_and_exit(){
    echo "${0}" '<gui|cui> <file>...' 1>&2
    exit "${1}"
}

if [[ "$#" -lt 1 ]]; then
    usage_and_exit 1
fi

if [[ "$1" = gui ]] || [[ "$1" = cui ]]; then
   readonly MODE="$1"
   shift
else
   usage_and_exit 1
fi

readonly EMACSCLIENT_=${MY_EMACSCLIENT:-emacsclient}

is_gui_running(){
    local window_system
    window_system="$(${EMACSCLIENT_} --alternate-editor= -e '(window-system)')"
    readonly window_system
    [[ "${window_system}" = "x" ]] ||
       [[ "${window_system}" = "ns" ]]
}

case "${MODE}" in
    gui)
        if is_gui_running; then
            "${EMACSCLIENT_}" --alternate-editor= -n -- "$@"
        else
            "${EMACSCLIENT_}" --alternate-editor= -c -n -- "$@"

            # Run within terminal when X is not supported.
            if is_gui_running; then
                :
            else
                "${0%/*}"/e.sh cui "$@"
            fi
        fi
        "${EMACSCLIENT_}" --alternate-editor= -e '(raise-frame)' > /dev/null
        if command -v wmctrl 2>&1 /dev/null; then
           wmctrl -a :ACTIVE:
        fi
        ;;
    cui)
        "${EMACSCLIENT_}" --alternate-editor= -t -- "$@"
        ;;
    *)
        usage_and_exit 1
        ;;
esac
