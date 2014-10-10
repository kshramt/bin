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
      echo "${program_name}" '< EQUATION.tex > EQUATION.pdf'
   } > /dev/stderr
   exit 1
}

if [[ $# -ne 0 ]]; then
   usage_and_exit
fi

cd "${TMP_DIR}"

readonly base_name=main
readonly tex_file="${base_name}".tex
readonly pdf_file="${base_name}".pdf
readonly log_dir="${HOME}"/d/log/"${program_name}"
mkdir -p "${log_dir}"
readonly log_file="${log_dir}"/"$($(dirname "${0}")/iso_8601_time.sh)".tex
cat > "${log_file}"

{
   cat <<EOF
%\RequirePackage[l2tabu, orthodox]{nag}
\documentclass{ltjsarticle}
\usepackage[ipaex, deluxe, expert]{luatexja-preset}
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

lualatex "${tex_file}" > /dev/stderr
pdfcrop --margins=1 "${pdf_file}" cropped.pdf > /dev/stderr
{
   echo 'InfoKey: '"${program_name}"
   echo InfoValue: "$(base64 "${log_file}" | tr -d '\n')"
} | pdftk cropped.pdf update_info_utf8 - output /dev/stdout
