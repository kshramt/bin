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
        "$@"
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

readonly MODE=${opt_mode:-undefined}
readonly EMACS_=${MY_EMACS:-emacs}
readonly EMACSCLIENT_=${MY_EMACSCLIENT:-emacsclient}
readonly SIGNALS_TO_TRAP='SIGHUP SIGTERM'

if ${EMACSCLIENT_} -e '()' > /dev/null 2>&1 ; then
    :
else
    (
        trap '' ${SIGNALS_TO_TRAP}
        exec ${EMACS_} --daemon
    )
fi

case "${MODE}" in
    gui)
        is_gui_running(){
            local emacsclient_="${1}"
            [[ "$(${emacsclient_} -e '(window-system)')" = "x" ]]
        }

        if is_gui_running ${EMACSCLIENT_}; then
            (
                trap '' ${SIGNALS_TO_TRAP}
                exec ${EMACSCLIENT_} -n -- "$@"
            )
        else
            (
                trap '' ${SIGNALS_TO_TRAP}
                exec ${EMACSCLIENT_} -c -n -- "$@"
            )

            # Run within terminal when X is not supported.
            if is_gui_running ${EMACSCLIENT_}; then
                :
            else
                "${0%/*}"/e.sh --mode=cui "$@"
            fi
        fi
        "${EMACSCLIENT_}" -e '(raise-frame)' > /dev/null
        if which -s wmctrl; then
           wmctrl -a :ACTIVE:
        fi
        ;;
    cui)
        (
            trap '' ${SIGNALS_TO_TRAP}
            exec ${EMACSCLIENT_} -t -- "$@"
        )
        ;;
    *)
        usage_and_exit 1
        ;;
esac
