#!/bin/bash

# set -xv
set -o nounset
set -o errexit
set -o pipefail
set -o noclobber

usage_and_exit(){
   echo 'rake -P |' $(basename "${0}") '| dot -Tpdf > workflow.pdf'
   exit 1
}

if [[ $# -ne 0 ]]; then
   usage_and_exit
fi

quote(){
   echo "\"$1\""
}

decorate(){
   local node="$1"
   case "${node}" in
      *bin/*)
	 echo "$(quote ${node}) [fillcolor=pink]"
	 ;;
      *data/*)
	 echo "$(quote ${node}) [fillcolor=orange]"
	 ;;
      *template/*)
	 echo "$(quote ${node}) [fillcolor=orange]"
	 ;;
      *work/*)
	 echo "$(quote ${node}) [fillcolor=yellow]"
	 ;;
      *report/*)
	 echo "$(quote ${node}) [fillcolor=\"#aaffaa\"]"
	 ;;
      *doc/*)
	 echo "$(quote ${node}) [fillcolor=\"#aaffaa\"]"
	 ;;
      *)
	 quote "${node}"
	 ;;
   esac
}

cat <<EOF
digraph {
   graph [rankdir=LR]
   node [shape=plaintext]
   edge [color=gray]
EOF

while read line
do
   if [[ "${line}" =~ ^rake\  ]]; then
      current_node="${line:5}"
      echo "   $(decorate ${current_node})"
   else
      echo "   $(decorate ${line})"
      echo "   $(quote ${current_node}) -> $(quote ${line})"
   fi
done

cat <<EOF
}
EOF
