#!/bin/bash

#set -xv
set -o nounset
set -o errexit
set -o pipefail

usage_and_exit(){
    echo ${0} -f GRD_FILE -n [N_CONTOUR] 1>&2
    exit ${1:-1}
}

if [[ ${#} -lt 2 ]]; then
    usage_and_exit 1
fi

readonly DIR="$(dirname "$0")"
readonly GMT="${MY_GMT:-GMT}"

opts=$(
    getopt \
        --unquoted \
        --options hf:n: \
        --longoptions help,file:,n_contour: \
        -- \
        "${@}"
)
set -- ${opts} # DO NOT quote.

while true
do
    case "${1}" in
        "-h" | "--help")
            usage_and_exit 0
            ;;
        "-f" | "--file")
            opt_f="${2}"
            shift
            ;;
        "-n" | "--n_contour")
            opt_n="${2}"
            shift
            ;;
        --)
            shift
            break
            ;;
        *)
            usage_and_exit 1
            ;;
    esac
    shift
done

readonly DATA_FILE="${opt_f}"
readonly N_CONTOUR="${opt_n:-10}"

readonly RANGES="$("${DIR}"/parse_grdinfo.rb.sh "${DATA_FILE}" '#{w}/#{e}/#{s}/#{n}')"
readonly ZS="$("${DIR}"/parse_grdinfo.rb.sh "${DATA_FILE}" '#{z0}/#{z1}/#{(z1 - z0)/200.0}')"
readonly Z_INC="$("${DIR}"/parse_grdinfo.rb.sh "${DATA_FILE}" "#{((z1 - z0)/${N_CONTOUR})}")"
readonly TICK_INTERVAL="$("${DIR}"/parse_grdinfo.rb.sh "${DATA_FILE}" '#{((e - w)/5.0).abs}/#{((n - s)/5.0).abs}')"
readonly CPT_FILE="$(mktemp)"

if [[ "$("${GMT}" --version)" =~ 5* ]]; then
   # todo: specify size matching -R (ex. 45cx25c)
   "${GMT}" gmtset PS_MEDIA a4
   "${GMT}" gmtset PS_PAGE_ORIENTATION portrait
   "${GMT}" gmtset PROJ_LENGTH_UNIT cm
   "${GMT}" gmtset FORMAT_GEO_MAP D
    readonly GRDIMAGE_INTERPOLATE_OPTION=-nb
else
   "${GMT}" gmtset PAPER_MEDIA a4+
   "${GMT}" gmtset PAGE_ORIENTATION portrait
   "${GMT}" gmtset MEASURE_UNIT cm
   "${GMT}" gmtset PLOT_DEGREE_FORMAT D
    readonly GRDIMAGE_INTERPOLATE_OPTION=-Sb
fi

"${GMT}" makecpt \
    -Crainbow \
    -T"${ZS}" \
    > "${CPT_FILE}"

{
    "${GMT}" psbasemap \
        -JX15c \
        -R"${RANGES}" \
        -B"${TICK_INTERVAL}" \
        -U \
        -K
    "${GMT}" grdimage \
        "${DATA_FILE}" \
        -JX \
        -R \
        -C"${CPT_FILE}" \
        "${GRDIMAGE_INTERPOLATE_OPTION}" \
        -U \
        -O \
        -K
    "${GMT}" grdcontour \
        "${DATA_FILE}" \
        -JX \
        -R \
        -C"${Z_INC}" \
        -S"${N_CONTOUR}" \
        -O
}
