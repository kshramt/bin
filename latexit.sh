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
# create a PDF

${program_name} [options] 'e^{i\pi} + 1 = 0' >| eq1.pdf
${program_name} [options] < eq1.tex >| eq1.pdf
# -h, --help: print help message
# -cLATEX, --command=LATEX: set LaTeX engine [pdflatex]

# extract a formula from a PDF

${program_name} -p eq1.pdf
# -p, --print: print a LaTeX formula in a PDF file
# -P, --print-full: print a formula in a PDF file as a self-contained LaTeX document
EOF
   } 1>&2
   exit "${1:-1}"
}


opts=$(
   getopt \
      --unquoted \
      --options hp:P:c: \
      --longoptions help,print:,print-full:,command: \
      -- \
      "$@"
)
set -- ${opts} # DO NOT quote.


readonly caller_dir="$(pwd)"
is_opt_print=false
is_opt_print_full=false
while true
do
   case "${1}" in
      "-h" | "--help")
         usage_and_exit 0
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



readonly latex="${opt_command:-pdflatex}"
{
   cat <<EOF
%\RequirePackage[l2tabu, orthodox]{nag}
EOF
   if [[ "${latex}" = "lualatex" ]]; then
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
