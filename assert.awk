function assert(cond, msg){
    if(! cond){
        print "ASSERTION FAILURE: " msg > "/dev/stderr"
        exit 1
    }
}
