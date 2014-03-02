#!/bin/bash

# set -xv
set -o nounset
set -o errexit
set -o pipefail
set -o noclobber

readonly TMP_DIR="$(mktemp -d)"

trap finalize EXIT

finalize(){
   \rm -fr "${TMP_DIR}"
}

usage_and_exit(){
   echo $(basename "${0}") '< EQUATION.tex > EQUATION.pdf' > /dev/stderr
   exit 1
}

if [[ $# -ne 0 ]]; then
   usage_and_exit
fi

(
   cd "${TMP_DIR}"

   base_name=main
   tex_file="${base_name}".tex
   pdf_file="${base_name}".pdf
   equation="$(cat | tr '\n' ' ')"

   {
      cat <<EOF
\RequirePackage[l2tabu, orthodox]{nag}
\documentclass{ltjsarticle}
\usepackage[ipaex, deluxe, expert]{luatexja-preset}
\usepackage[a0paper, landscape, margin=10mm]{geometry}
\usepackage[usenames]{color}
%\usepackage{microtype}
\usepackage{verbatim}
\usepackage[version=3]{mhchem}
\usepackage{amsmath, amssymb, amsthm}
\usepackage{mathrsfs}
\usepackage{breakurl}
\usepackage{siunitx}
\usepackage{algorithm2e}
\usepackage{bm}

\DeclareMathOperator{\D}{\partial}
\newcommand{\dd}[1]{\,d#1}
\newcommand{\f}[2]{\frac{#1}{#2}}

\pagenumbering{gobble}

\begin{document}
\begin{align*}
EOF
      echo "${equation}"
      cat <<EOF
\end{align*}
\end{document}
EOF
   } > "${tex_file}"

   cat <<EOF | pdftk cropped.pdf update_info_utf8 - output /dev/stdout
lualatex "${tex_file}" > /dev/stderr
pdfcrop --margins=1 "${pdf_file}" cropped.pdf > /dev/stderr
InfoKey: Equation
InfoValue: ${equation}
EOF
)
