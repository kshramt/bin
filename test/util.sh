readonly target="$(dirname "${0}")"/../"$(basename "${0}")"

trap finalize EXIT

finalize(){
   if [[ $? = 0 ]]; then
      echo PASS "${0}"
   else
      echo FAIL "${0}" > /dev/stderr
      exit $?
   fi
}
