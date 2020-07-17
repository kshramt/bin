#!/bin/bash

set -o nounset
set -o errexit
set -o pipefail

print_usage(){
    echo "${0}" EXECUTABLE_FILE TIMESTAMP_FILE
    echo "# Run EXECUTABLE_FILE and update TIMESTAMP_FILE if EXECUTABLE_FILE is newer than TIMESTAMP_FILE."
}

if [[ $# -ne 2 ]]; then
    print_usage
    exit 1
fi

exe=$(readlink -f ${1})
comp=${2}
if [[ "${exe}" -nt "${comp}" ]]; then
    ${exe} && touch ${comp}
fi
