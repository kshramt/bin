#!/bin/bash

set -o nounset
set -o errexit
set -o pipefail

usage_and_exit(){
    echo ${0} '--mode=[gui|cui] FILES' 1>&2
    exit ${1:-1}
}

if [[ ${#} -lt 1 ]]; then
    usage_and_exit 1
fi

opts=$(
    getopt \
        --unquoted \
        --options hm: \
        --longoptions help,mode: \
        -- \
        "${@}"
)
set -- ${opts} # DO NOT quote.

while true
do
    case "${1}" in
        -h | --help)
            usage_and_exit 0
            ;;
        -m | --mode)
            opt_mode="${2}"
            shift
            ;;
        --)
            shift
            break
            ;;
        *)
            break
            ;;
    esac
    shift
done

readonly MODE="${opt_mode}"
readonly EMACS_=${MY_EMACS:-emacs}
readonly EMACSCLIENT_=${MY_EMACSCLIENT:-emacsclient}

if ${EMACSCLIENT_} -e '()' > /dev/null 2>&1 ; then
    :
else
    (
        trap '' SIGHUP
        exec ${EMACS_} --daemon
    )
fi

case "${MODE}" in
    gui)
        is_gui_running(){
            local emacsclient_="${1}"
            [ "$(${emacsclient_} -e '(window-system)')" = "x" ]
        }

        if is_gui_running ${EMACSCLIENT_}; then
            ${EMACSCLIENT_} -n -- "$@"
        else
            ${EMACSCLIENT_} -c -n -- "$@"

            # Run within terminal when X is not supported.
            if is_gui_running ${EMACSCLIENT_}; then
                :
            else
                em.bash "$@"
            fi
        fi
        ;;
    cui)
        ${EMACSCLIENT_} -t -- "$@"
        ;;
    *)
        usage_and_exit 1
        ;;
esac
