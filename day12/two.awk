#!/usr/bin/env awk -f
BEGIN {
    FPAT = "[[:digit:]]+"
    DEBUG = 0
}
$0 !~ /^[[:digit:]]+ <-> [[:digit:]]+(, [[:digit:]]+)*$/ {
    print "DATA ERROR"
    exit _exit=1
}
{
    DISTANCE[$1][0][$1] = 0
    for (i = 2; i <= NF; ++i) {
        DISTANCE[$1][1][$i] = DISTANCE[$i][1][$1] = 1
        PROGRAMS_TO_CHECK[$1] = PROGRAMS_TO_CHECK[$i] = 1
    }
}
END {
    if (_exit) {
        exit _exit
    }
    while (length(PROGRAMS_TO_CHECK) > 0) {
        for (start in PROGRAMS_TO_CHECK) {
            break
        }
        if (DEBUG) {
            print "Programs to check:"
            for (i in PROGRAMS_TO_CHECK) {
                print i
            }
            print "creating group including", start
        }
        GROUP[start][start] = 0
        delete PROGRAMS_TO_CHECK[start]
        for (dist = 0; length(DISTANCE[start][dist]); ++dist) {
            for (src in DISTANCE[start][dist]) {
                for (dst in DISTANCE[src][1]) {
                    if (!(dst in GROUP[start])) {
                        delete PROGRAMS_TO_CHECK[dst]
                        GROUP[start][dst] = dist + 1
                        DISTANCE[start][dist + 1][dst] = dist + 1
                    }
                }
            }
        }
    }
    if (DEBUG) {
        print "groups:"
        for (i in GROUP) {
            print i, "of size", length(GROUP[i])
        }
    }
    print length(GROUP)
}
