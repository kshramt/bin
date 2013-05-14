emacs_=${MY_EMACS:-emacs}
emacsclient_=${MY_EMACSCLIENT:-emacsclient}

if ${emacsclient_} -e '()' > /dev/null 2>&1 ; then
    :
else
    output=$(mktemp)
    nohup ${emacs_} --daemon > ${output} &
    wait
    cat ${output}
fi
