#!/bin/bash

# set -xv
set -o nounset
set -o errexit
set -o pipefail
set -o noclobber


readonly program_name="${0##*/}"
usage_and_exit(){
   {
      cat <<EOF
Make a PDF file:
${program_name} [options] 'e^{i\pi} + 1 = 0' >| eq1.pdf
${program_name} [options] < eq1.tex >| eq1.pdf

Extract a LaTeX formula from a PDF file:
${program_name} --print eq1.pdf
${program_name} --print-full eq1.pdf

[options]:
-h, --help: Print help message
--ja: Allow Japanese (--command=lualatex is automatically set)
--bold: Use bold fonts for presentation
-c<latex>, --command=<latex>: Set LaTeX engine [lualatex]
-p, --print: Print a LaTeX formula in a PDF file
-P, --print-full: Print a LaTeX formula in a PDF file as a standalone LaTeX document
EOF
   } 1>&2
   exit "${1:-1}"
}


opts="$(
   getopt \
      --options hp:P:c: \
      --longoptions help,ja,bold,print:,print-full:,command: \
      -- \
      "$@"
)"
eval set -- "$opts"


readonly caller_dir="$(pwd)"
is_opt_print=false
is_opt_print_full=false
latex=lualatex
ja=false
bold=false
while true
do
   case "${1}" in
      "-h" | "--help")
         usage_and_exit 0
         ;;
      --ja)
         ja=true
         ;;
      --bold)
         bold=true
         ;;
      "-p" | "--print")
         opt_print_file="$caller_dir/$2"
         is_opt_print=true
         break
         ;;
      "-P" | "--print-full")
         opt_print_full_file="$caller_dir/$2"
         is_opt_print_full=true
         break
         ;;
      "-c" | "--command")
         latex="$2"
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

readonly tmp_dir="$(mktemp -d)"
trap finalize EXIT
finalize(){
   rm -fr "${tmp_dir}"
}
cd "$tmp_dir"


readonly equation_file=equation.tex
readonly base_name=main
readonly tex_file="$base_name".tex


if [[ "$is_opt_print" = true ]]; then
   pdfdetach -saveall "$opt_print_file"

   if [[ -r "$equation_file" ]]; then
      cat "$equation_file"
   else
      pdftk "$opt_print_file" dump_data_utf8 |
      grep -A1 'InfoKey: '"$program_name" |
      tail -n1 |
      sed -e 's/InfoValue: //' |
      base64 --decode
   fi
   exit
fi
if [[ "$is_opt_print_full" = true ]]; then
   pdfdetach -saveall "$opt_print_full_file"
   cat "$tex_file"
   exit
fi


{
   if [[ $# -ne 0 ]]; then
      echo "$@"
   else
      cat
   fi
} > "$equation_file"



{
   cat <<EOF
%\RequirePackage[l2tabu, orthodox]{nag}
EOF
   if [[ "$ja" = true ]]; then
      latex=lualatex
      cat <<EOF
\documentclass{ltjsarticle}
\usepackage[ipa, expert]{luatexja-preset}
EOF
   else
      cat <<EOF
\documentclass{article}
EOF
   fi
cat <<EOF
\usepackage[a0paper, landscape, margin=10mm]{geometry}
\usepackage[active, tightpage]{preview}
\setlength\PreviewBorder{1pt}
\usepackage{amsmath, amssymb, amsthm}
\usepackage{embedfile}

\usepackage{mathrsfs}
\usepackage[usenames]{color}
\usepackage{siunitx}
\usepackage{bm}

\DeclareMathOperator{\D}{\partial}
\newcommand{\dd}[1]{\,d#1}
\newcommand{\f}[2]{\frac{#1}{#2}}

\embedfile{$equation_file}
\embedfile{$tex_file}
\begin{document}
\thispagestyle{empty}
EOF
if [[ "$bold" = true ]]; then
   echo '\bfseries \mathversion{bold}'
fi
cat <<EOF
\begin{preview}
  \$\displaystyle
    \begin{aligned}
EOF
   cat "$equation_file"
   cat <<EOF
    \end{aligned}
  \$
\end{preview}
\end{document}
EOF
} > "$tex_file"


"$latex" "$tex_file" 1>&2
readonly pdf_file="${base_name}".pdf
cat "$pdf_file"

readonly log_dir="${HOME}"/d/log/"${program_name}"
mkdir -p "${log_dir}"
mv "$equation_file" "${log_dir}"/"$(${0%/*}/iso_8601_time.sh)".tex
