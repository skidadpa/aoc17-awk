#!/usr/bin/env awk -f
BEGIN {
    FPAT="[[:lower:]]+|[[:digit:]]+"
    DEBUG = 1
}
$0 !~ /^[[:lower:]]+ \([[:digit:]]+\)( -> [[:lower:]]+(, [[:lower:]]+)*)*/ {
    print "DATA ERROR"
    exit _exit=1
}
{
    WEIGHTS[$1] = int($2)
    for (i = 3; i <= NF; ++i) {
        BRANCHES[$1][$i] = 1
        SUPPORTER[$i] = $1
    }
}
END {
    if (_exit) {
        exit _exit
    }
    for (b in BRANCHES) {
        if (!(b in SUPPORTER)) {
            print b
        }
    }
}
