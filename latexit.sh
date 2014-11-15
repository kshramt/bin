#!/bin/bash

# set -xv
set -o nounset
set -o errexit
set -o pipefail
set -o noclobber

readonly TMP_DIR="$(mktemp -d)"

trap finalize EXIT

finalize(){
   rm -fr "${TMP_DIR}"
}

readonly program_name="$(basename "${0}")"
usage_and_exit(){
   {
      echo "${program_name}" "[options] 'e^{i\pi} + 1 = 0' >| eq1.pdf"
      echo "${program_name}" '[options] < eq1.tex >| eq1.pdf'
      echo "# -h, --help: print help message"
      echo "# -cLATEX, --command=LATEX: set LaTeX engine [lualatex]"
   } > /dev/stderr
   exit "${1:-1}"
}


opts=$(
   getopt \
      --unquoted \
      --options hc: \
      --longoptions help,command: \
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
      "-c" | "--command")
         opt_command="${2}"
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
readonly latex="${opt_command:-lualatex}"


cd "${TMP_DIR}"

readonly base_name=main
readonly tex_file="${base_name}".tex
readonly pdf_file="${base_name}".pdf
readonly log_dir="${HOME}"/d/log/"${program_name}"
mkdir -p "${log_dir}"
readonly log_file="${log_dir}"/"$($(dirname "${0}")/iso_8601_time.sh)".tex
{
   if [[ $# -ne 0 ]]; then
      echo "$@"
   else
      cat
   fi
} > "${log_file}"

{
   cat <<EOF
%\RequirePackage[l2tabu, orthodox]{nag}
EOF
   if [[ "${latex}" = "lualatex" ]]; then
      cat <<EOF
\documentclass{ltjsarticle}
\usepackage[ipaex, deluxe, expert]{luatexja-preset}
EOF
   else
      cat <<EOF
\documentclass{article}
EOF
   fi
cat <<EOF
\usepackage[a0paper, landscape, margin=10mm]{geometry}
\usepackage[usenames]{color}
\usepackage{amsmath, amssymb, amsthm}
\usepackage{mathrsfs}
\usepackage{siunitx}
\usepackage{bm}

\DeclareMathOperator{\D}{\partial}
\newcommand{\dd}[1]{\,d#1}
\newcommand{\f}[2]{\frac{#1}{#2}}

\pagenumbering{gobble}

\begin{document}
\begin{align*}
EOF
   cat "${log_file}"
   cat <<EOF
\end{align*}
\end{document}
EOF
} > "${tex_file}"

"${latex}" "${tex_file}" > /dev/stderr
pdfcrop --margins=1 "${pdf_file}" cropped.pdf > /dev/stderr
{
   echo 'InfoKey: '"${program_name}"
   echo InfoValue: "$(base64 "${log_file}" | tr -d '\n')"
} | pdftk cropped.pdf update_info_utf8 - output /dev/stdout
