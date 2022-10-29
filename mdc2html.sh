#!/bin/bash

# set -xv
set -o nounset
set -o errexit
set -o pipefail
set -o noclobber

export IFS=$' \t\n'
export LANG=en_US.UTF-8
umask u=rwx,g=,o=


usage_and_exit(){
   {
      echo "${0##*/}" '[options] <path/to/file.mdc>'
      echo '--self-contained: write self contained HTML to standard output'
   } >&2
   exit "${1:-1}"
}


opts="$(
   getopt \
      --options h \
      --longoptions help \
      --longoptions verbose \
      --longoptions self-contained \
      -- \
      "$@"
)"
eval set -- "${opts}"


self_contained=false


while true
do
    case "$1" in
        -h | --help)
            usage_and_exit 0
            ;;
        --verbose)
            set -xv
            ;;
        --self-contained)
            self_contained=true
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


if [[ $# -ne 1 ]]; then
   usage_and_exit
fi


readonly mdc="$1"


: ${PANDOC_FLAGS:=--mathml --standalone --to=html5}
output=index.html
if [[ "${self_contained}" = "true" ]]; then
   PANDOC_FLAGS="${PANDOC_FLAGS} --self-contained"
   output=/dev/stdout
fi


cd "${mdc}"
${PANDOC:-pandoc} "${PANDOC_FLAGS}" index.md >| "${output}"
