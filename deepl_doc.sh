#!/bin/bash

# set -xv
set -o nounset
set -o errexit
set -o pipefail
set -o noclobber

export IFS=$' \t\n'
export LANG=C.UTF-8
umask u=rwx,g=,o=


usage_and_exit(){
   {
      echo "${0##*/}" '<input> <output>'
   } >&2
   exit "${1:-1}"
}

readonly dir="$(dirname "$0")"
readonly tmp_dir="$(mktemp -d)"

finalize(){
   rm -fr "${tmp_dir}"
}

trap finalize EXIT


if [[ $# -ne 2 ]]; then
   usage_and_exit
fi

readonly input="$1"
readonly output="$2"
readonly deepl_domain="${MY_DEEPL_DOMAIN:-api-free.deepl.com}"


curl https://"${deepl_domain}/v2/document" \
     -F "file=@${input}" \
     -F "auth_key=${MY_DEEPL_API_KEY}" \
     -F "target_lang=${TARGET_LANG:-JA}" \
     > "${tmp_dir}/job.json"

readonly document_id="$(jq --raw-output .document_id "${tmp_dir}/job.json")"
readonly document_key="$(jq --raw-output .document_key "${tmp_dir}/job.json")"

while true
do
   curl https://"${deepl_domain}"/v2/document/"${document_id}" \
	  -d auth_key="${MY_DEEPL_API_KEY}" \
	  -d document_key="${document_key}" \
        >| "${tmp_dir}/status.json"
   status="$(jq --raw-output .status "${tmp_dir}/status.json")"
   if [[ "${status}" == error ]]; then
      {
         cat "${tmp_dir}/job.json"
         cat "${tmp_dir}/status.json"
      } > /dev/stderr
      exit 1
   fi
   if [[ "${status}" == done ]]; then
      break
   fi
   cat "${tmp_dir}/status.json"; echo
   sleep 5;
done

mkdir -p "$(dirname "${output}")"

curl https://"${deepl_domain}"/v2/document/"${document_id}"/result \
	-d auth_key="${MY_DEEPL_API_KEY}" \
	-d document_key="${document_key}" \
      >| "${output}"
