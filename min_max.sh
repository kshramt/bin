#!/bin/sh

gawk \
'
BEGIN{
    OFMT = "%.17g"
    CONVFMT = "%.17g"
    x1 = "+inf" + 0
    x2 = "-inf" + 0
}

$1 < x1{x1 = $1}
$1 > x2{x2 = $1}

END{
    print x1 "\t" x2
}
'