#!/bin/bash

#set -xv
set -o nounset
set -o errexit
set -o pipefail
set -o noclobber

usage_and_exit(){
    echo "${0}" '-f GRD_FILE -n [N_CONTOUR]' 1>&2
    exit "${1:-1}"
}

if [[ "${#}" -lt 2 ]]; then
    usage_and_exit 1
fi

readonly DIR="$(dirname "$0")"
readonly GMT="${MY_GMT:-gmt}"

opts=$(
    getopt \
        --unquoted \
        --options hf:n: \
        --longoptions help,file:,n_contour: \
        -- \
        "$@"
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

# file w e s n z0 z1 dx dy nx ny
readonly GRD_INFO="$(${GMT} grdinfo -C "${DATA_FILE}")"
readonly W="$(echo "${GRD_INFO}" | cut -f2)"
readonly E="$(echo "${GRD_INFO}" | cut -f3)"
readonly S="$(echo "${GRD_INFO}" | cut -f4)"
readonly N="$(echo "${GRD_INFO}" | cut -f5)"
readonly Z0="$(echo "${GRD_INFO}" | cut -f6)"
readonly Z1="$(echo "${GRD_INFO}" | cut -f7)"
readonly RANGES="${W}/${E}/${S}/${N}"
readonly ZS="${Z0}/${Z1}/$(awk -v z0="${Z0}" -v z1="${Z1}" 'BEGIN{print (z1 - z0)/200}')"
readonly Z_INC="$(awk -v z0="${Z0}" -v z1="${Z1}" -v n="${N_CONTOUR}" 'BEGIN{print (z1 - z0)/n}')"
readonly TICK_INTERVAL="$(awk -v w="${W}" -v e="${E}" 'BEGIN{print (e - w)/5}')"/"$(awk -v s="${S}" -v n="${N}" 'BEGIN{print (n - s)/5}')"


cat <<EOF
#!/bin/bash

set -o nounset
set -o errexit


readonly CPT_FILE="\$(mktemp)"


EOF


if [[ "$(${GMT} --version 2>&1)" =~ ^5+ ]]; then
   cat <<EOF
# todo: specify size matching -R (e.g. 45cx25c) instead of a4
${GMT} gmtset PS_MEDIA a4
${GMT} gmtset PS_PAGE_ORIENTATION portrait
${GMT} gmtset PROJ_LENGTH_UNIT cm
${GMT} gmtset FORMAT_GEO_MAP D
readonly GRDIMAGE_INTERPOLATE_OPTION=-nb
EOF
else
   cat <<EOF
${GMT} gmtset PAPER_MEDIA a4+
${GMT} gmtset PAGE_ORIENTATION portrait
${GMT} gmtset MEASURE_UNIT cm
${GMT} gmtset PLOT_DEGREE_FORMAT D
readonly GRDIMAGE_INTERPOLATE_OPTION=-Sb
EOF
fi

cat <<EOF


${GMT} makecpt \\
   -Crainbow \\
   -T"${ZS}" \\
   >| "\${CPT_FILE}"

{
   ${GMT} psbasemap \\
      -JX15c \\
      -R"${RANGES}" \\
      -B"${TICK_INTERVAL}" \\
      -U \\
      -K
   ${GMT} grdimage \\
      "${DATA_FILE}" \\
      -JX \\
      -R \\
      -C"\${CPT_FILE}" \\
      "\${GRDIMAGE_INTERPOLATE_OPTION}" \\
      -Q \\
      -U \\
      -O \\
      -K
   ${GMT} grdcontour \\
      "${DATA_FILE}" \\
      -JX \\
      -R \\
      -C"${Z_INC}" \\
      -S"${N_CONTOUR}" \\
      -O
}
EOF
