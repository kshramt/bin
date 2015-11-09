#!/bin/bash

IFS=$' \t\n'

# set -xv
set -o nounset
set -o errexit
set -o pipefail
set -o noclobber

usage_and_exit(){
   {
      echo '# update GitBucket to <version>'
      echo "${0##*/}" '<version>'
   } >&2
   exit "${1:-1}"
}

if [[ $# -ne 1 ]] || [[ "$1" = '-h' ]] || [[ "$1" = '--help' ]]; then
   usage_and_exit
fi


readonly tmp_dir="$(mktemp -d)"

finalize(){
   rm -fr "${tmp_dir}"
}

trap finalize EXIT

readonly version="$1"

cd "$tmp_dir"
wget https://github.com/takezoe/gitbucket/releases/download/"$version"/gitbucket.war

cd /var/lib/tomcat7/webapps

readonly new_gitbucket_war=gitbucket.war."$version"
sudo cp -f "$tmp_dir"/gitbucket.war "$new_gitbucket_war"
sudo service tomcat7 stop
sudo ln -fs "$new_gitbucket_war" repository.war
sudo service tomcat7 start
