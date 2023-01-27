#!/usr/bin/env awk -f
BEGIN {
    FS = ""
    DEBUG = 0
}
($0 !~ /^[[:digit:]]+$/) {
    print "DATA ERROR"
    exit _exit=1
}
{
    sum = 0
    for (i = 1; i <= NF; ++i) {
        j = (i < NF) ? (i + 1) : 1
        if ($i == $j) {
            if (DEBUG > 1) {
                print i, $i, "==", $j, j
            }
            sum += $i
        } else {
            if (DEBUG > 1) {
                print i, $i, "!=", $j, j
            }
        }
    }
    if (DEBUG) {
        printf("%s => ", $0)
    }
    print sum
}
END {
    if (_exit) {
        exit _exit
    }
}
