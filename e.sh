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

uname_o="$(uname -o)"
readonly uname_o
if [[ "${uname_o}" = "Darwin" ]]; then
   for f in "$@"
   do
      if [[ ! -e "${f}" ]]; then
         mkdir -p "$(dirname "${f}")"
         touch "${f}"
      fi
      open -a Emacs.app "${f}"
   done
   exit
fi

readonly EMACS_=${MY_EMACS:-emacs}
readonly EMACSCLIENT_=${MY_EMACSCLIENT:-emacsclient}

if "${EMACSCLIENT_}" -e '()' > /dev/null 2>&1 ; then
    :
else
    ${EMACS_} --daemon
fi

case "${MODE}" in
    gui)
        is_gui_running(){
            local emacsclient_="${1}"
            local window_system
            window_system="$(${emacsclient_} -e '(window-system)')"
            readonly window_system
            [[ "${window_system}" = "x" ]] ||
               [[ "${window_system}" = "ns" ]]
        }
        if is_gui_running "${EMACSCLIENT_}"; then
            "${EMACSCLIENT_}" -n -- "$@"
        else
            "${EMACSCLIENT_}" -c -n -- "$@"

            # Run within terminal when X is not supported.
            if is_gui_running "${EMACSCLIENT_}"; then
                :
            else
                "${0%/*}"/e.sh cui "$@"
            fi
        fi
        "${EMACSCLIENT_}" -e '(raise-frame)' > /dev/null
        if command -v wmctrl 2>&1 /dev/null; then
           wmctrl -a :ACTIVE:
        fi
        ;;
    cui)
        "${EMACSCLIENT_}" -t -- "$@"
        ;;
    *)
        usage_and_exit 1
        ;;
esac
