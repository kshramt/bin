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
-c<latex>, --command=<latex>: Set LaTeX engine [lualatex]
--huge: use Huge font
-p, --print: Print a LaTeX formula in a PDF file
-P, --print-full: Print a LaTeX formula in a PDF file as a standalone LaTeX document
EOF
   } 1>&2
   exit "${1:-1}"
}


opts="$(
   getopt \
      --options hp:P:c: \
      --longoptions help,huge,print:,print-full:,command: \
      -- \
      "$@"
)"
eval set -- "$opts"


is_huge=false
is_opt_print=false
is_opt_print_full=false
latex=lualatex
while true
do
   case "${1}" in
      "-h" | "--help")
         usage_and_exit 0
         ;;
      "--huge")
         is_huge=true
         ;;
      "-p" | "--print")
         opt_print_file="$(readlink -f "$2")"
         is_opt_print=true
         break
         ;;
      "-P" | "--print-full")
         opt_print_full_file="$(readlink -f "$2")"
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
\documentclass{article}
\usepackage[a0paper, landscape, margin=10mm]{geometry}
\usepackage[active, tightpage]{preview}
\setlength\PreviewBorder{1pt}
\usepackage{amsmath, amssymb, amsthm}
\usepackage{newtxtext, newtxmath}
\usepackage{embedfile}

\usepackage{mathrsfs}
\usepackage[usenames]{color}
\usepackage{siunitx}
\usepackage{bm}

\newcommand{\dd}[1]{\,d#1}
\newcommand{\pr}[1]{\left(#1\right)}

\embedfile{$equation_file}
\embedfile{$tex_file}
\begin{document}
EOF
if [[ "$is_huge" = true ]]; then
   echo '\Huge'
fi
cat <<EOF
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

readonly dir="${0%/*}"
name="${log_dir}"/"$("$dir"/iso_8601_time.sh)"
mv "$equation_file" "$name".tex
mv "$pdf_file" "$name".pdf
