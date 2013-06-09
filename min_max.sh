BEGIN{
    OFMT = "%.17g"
    CONVFMT = "%.17g"
    x1 = "+inf" + 0
    x2 = "-inf" + 0
    y1 = "+inf" + 0
    y2 = "-inf" + 0
}

$1 < x1{x1 = $1}
$1 > x2{x2 = $1}
$2 < y1{y1 = $2}
$2 > y2{y2 = $2}

END{
    print x1 "\t" x2 "\t" y1 "\t" y2
}
