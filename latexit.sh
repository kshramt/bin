#!/bin/bash

# set -xv
set -o nounset
set -o errexit
set -o pipefail
set -o noclobber


readonly program_name="${0##*/}"
usage_and_exit(){
   local msg="
Examples:
${program_name} [options] --to=svg 'e^{i\pi} + 1 = 0' >| eq1.svg
${program_name} [options] < eq1.tex >| eq1.pdf

${program_name} --print eq1.pdf
${program_name} --print-full eq1.svg

[options]:
-h, --help: Print help message
--color=<r,g,b>: RGB color in 0 <= x <= 1 [0,0,0]
-c<latex>, --command=<latex>: Set LaTeX engine [pdflatex]
--huge: use Huge font
-p, --print: Print a LaTeX formula embedded in a PDF or SVG file
-P, --print-full: Print a standalone LaTeX document embedded in a PDF or SVG file
--to=<format>: Output format (one of pdf and svg) [pdf]
"
   local status="${1:-1}"
   if [[ $status -eq 0 ]]; then
      echo "$msg"
   else
      echo "$msg" 1>&2
   fi
   exit "$status"
}


opts="$(
   getopt \
      --options hp:P:c: \
      --longoptions help,color:,huge,print:,print-full:,to:,command: \
      -- \
      "$@"
)"
eval set -- "$opts"


color='0,0,0'
is_huge=false
is_opt_print=false
is_opt_print_full=false
to=pdf
latex=pdflatex
while true
do
   case "${1}" in
      "-h" | "--help")
         usage_and_exit 0
         ;;
      "--color")
         color="$2"
         shift
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
      "--to")
         to="$2"
         shift
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
   case "$opt_print_file" in
      *.pdf)
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
         ;;
      *.svg)
         tail -n4 "$opt_print_file" |
            grep latexit_equation: |
            sed -e 's/latexit_equation://' |
            base64 -d
         ;;
      *)
         usage_and_exit 1
         ;;
   esac
   exit
fi

if [[ "$is_opt_print_full" = true ]]; then
   case "$opt_print_full_file" in
      *.pdf)
         pdfdetach -saveall "$opt_print_full_file"
         cat "$tex_file"
         ;;
      *.svg)
         tail -n4 "$opt_print_full_file" |
            grep latexit_tex: |
            sed -e 's/latexit_tex://' |
            base64 -d
         ;;
      *)
         usage_and_exit 1
         ;;
   esac
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
\usepackage{libertine}
\usepackage[libertine]{newtxmath}
\usepackage{embedfile}

\DeclareMathAlphabet{\mathpzc}{OT1}{pzc}{m}{it}
\usepackage{mathdots}
\usepackage{mathrsfs}
\usepackage{mathtools}
\usepackage{xcolor}
\usepackage{siunitx}
\newcommand\hmmax{0}
\newcommand\bmmax{0}
\usepackage{bm}

\newcommand{\dd}[1]{d#1}
\newcommand{\tr}[1]{\ensuremath{\,{}^{t}\!#1}}
\newcommand{\norm}[1]{\ensuremath{\left\lVert#1\right\rVert}}
\newcommand{\abs}[1]{\ensuremath{\left|#1\right|}}

\DeclarePairedDelimiter{\pr}{(}{)}

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
    \color[rgb]{$color}
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
readonly log_dir="${HOME}"/d/log/"${program_name}"
mkdir -p "${log_dir}"

readonly dir="${0%/*}"
name="${log_dir}"/"$("$dir"/iso_8601_time.sh)"
mv "$equation_file" "$name".tex
mv "$pdf_file" "$name".pdf


case "$to" in
   pdf)
      cat "$name".pdf
      ;;
   svg)
      pdftocairo -svg "$name".pdf -
      echo '<!--'
      echo -n 'latexit_equation:'
      base64 --wrap=0 "$name".tex
      echo
      echo -n 'latexit_tex:'
      base64 --wrap=0 "$tex_file"
      echo
      echo '-->'
      ;;
   *)
      usage_and_exit
      ;;
esac
