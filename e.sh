#!/bin/sh

set -o nounset
set -o errexit

usage_and_exit(){
    echo "${0}" '<gui|cui> <file>...' 1>&2
    exit "${1:-1}"
}

if [ "$#" -lt 1 ]; then
    usage_and_exit 1
fi

if [ "$1" = gui ] || [ "$1" = cui ]; then
   readonly MODE="$1"
   shift
else
   usage_and_exit 1
fi

readonly EMACS_=${MY_EMACS:-emacs}
readonly EMACSCLIENT_=${MY_EMACSCLIENT:-emacsclient}
readonly SIGNALS_TO_TRAP='HUP TERM'

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
            [ "$(${emacsclient_} -e '(window-system)')" = "x" ] ||
               [ "$(${emacsclient_} -e '(window-system)')" = "ns" ]
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
                "${0%/*}"/e.sh cui "$@"
            fi
        fi
        "${EMACSCLIENT_}" -e '(raise-frame)' > /dev/null
        if which wmctrl 2>&1 /dev/null; then
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
