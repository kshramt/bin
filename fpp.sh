#!/bin/bash

IFS=$' \t\n'
umask u=rwx,g=,o=


# set -xv
set -o nounset
set -o errexit
set -o pipefail
set -o noclobber


${MY_CPP:-cpp} -P -C -nostdinc "$@"
