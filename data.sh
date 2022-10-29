#!/bin/bash

IFS=$' \t\n'

# set -xv
set -o nounset
set -o errexit
set -o pipefail
set -o noclobber

usage_and_exit(){
   {
      prog="${0##*/}"
      cat <<EOF
${prog} add <uri> <file>
# Register <file>

${prog} check
# Check if data have not modified

${prog} fetch <uri>
# Download files of <uri> and register them

${prog} search <uri> <file>
# Search for <file> of <uri>

${prog} get <uri> <file>
# Get hashes for <file> of <uri>
# <uri> is fetched if <file> does not exist
# Multiple hashes will be returned if <file> of <uri> is not unique

${prog} grep <arg> [<args>...]
# grep meta data
EOF
   } >&2
   exit "${1:-1}"
}

readonly dir="${0%/*}"
readonly awk="${MY_AWK:-awk}"


if [[ $# -lt 1 ]]; then
   usage_and_exit
fi


readonly hash_command=sha256sum
readonly data_dir="${MY_DATA_DIR:-"${HOME}"/d/data}"
readonly hash_dir="${data_dir}"/hash


raise(){
   echo "$@" >&2
   exit 1
}


metas(){
   find "${hash_dir}" -mindepth 2 -maxdepth 2 -name 'meta.tsv' -type f
}


prepare_tmp_dir(){
   if [[ -z "${tmp_dir:-}" ]]; then
      readonly tmp_dir="$(mktemp -d)"
      finalize_tmp_dir(){
         rm -fr "${tmp_dir}"
      }
      trap finalize_tmp_dir EXIT
   fi
}


_add(){
   [[ $# -ne 2 ]] && usage_and_exit
   uri="$1"
   file="$2"
   [[ ! -r "${file}" ]] && raise "${file}" unreadable
   read hash _ < <(${hash_command} "${file}")

   d="${hash_dir}"/"${hash}"
   mkdir -p "${d}"
   if [[ ! -e "${d}"/data ]]; then
      {
         cp --dereference "${file}" "${d}"/data
         chmod ugo-w "${d}"/data
      } &
   fi
   file_base="$(basename "${file}")"
   huf="hash:${hash}	uri:${uri}	file:${file_base}"
   grep -sq "${huf}" "${d}"/meta.tsv || echo "${huf}" >> "${d}"/meta.tsv
   [[ ! -e "${d}"/"${file_base}" ]] && ln -s data "${d}"/"${file_base}"
   wait
   echo "${huf}"
}


_check(){
   [[ $# -ne 0 ]] && usage_and_exit
   cd "${hash_dir}"
   ls -U -1 |
      ${awk} '{print $1 "  " $1 "/data"}' |
      ${hash_command} --check --quiet
}


_fetch(){
   [[ $# -ne 1 ]] && usage_and_exit
   prepare_tmp_dir
   cd "${tmp_dir}"
   uri="$1"
   wget "${uri}"
   while read file
   do
      _add "${uri}" "${file}"
   done < <(find . -maxdepth 1 -type f)
}


_search(){
   [[ $# -ne 2 ]] && usage_and_exit
   uri="$1"
   file="$2"
   file_base="$(basename "${file}")"
   metas |
      xargs cat |
      { grep "	uri:${uri}	file:${file_base}$" || : ; } |
      cut -f1 |
      sed -e 's/hash://g'
}


_get(){
   [[ $# -ne 2 ]] && usage_and_exit
   uri="$1"
   file="$2"
   file_base="$(basename "${file}")"
   hashes="$(_search "${uri}" "${file}")"
   if [[ -z "${hashes}" ]]; then
      _fetch "${uri}" > /dev/null
      hashes="$(_search "${uri}" "${file}")"
   fi
   [[ -z "${hashes}" ]] && raise "unable to downlaod ${file} of ${uri}"
   [[ "$(echo "${hashes}" | wc -l)" -ne 1 ]] && raise "multiple candidates for ${file} of ${uri}"$'\n'"${hashes}"
   echo "${hashes}"
}


_grep(){
   metas | xargs cat | grep --color=auto "$@"
}


case "$1" in
   add)
      shift
      _add "$@"
      ;;
   check)
      shift
      _check "$@"
      ;;
   fetch)
      shift
      _fetch "$@"
      ;;
   search)
      shift
      _search "$@"
      ;;
   get)
      shift
      _get "$@"
      ;;
   grep)
      shift
      _grep "$@"
      ;;
   *)
      usage_and_exit
      ;;
esac
