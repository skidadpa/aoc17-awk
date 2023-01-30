#!/usr/bin/env awk -f
BEGIN {
    FS = ","
    DEBUG = 0
}
$0 !~ /^(n|s|(ne)|(se)|(nw)|sw)(,(n|s|(ne)|(se)|(nw)|sw))*$/ {
    print "DATA ERROR"
    exit _exit=1
}
{
    x = y = 0
    for (i = 1; i <= NF; ++i) {
        switch ($i) {
        case "n":
            ++y
            break
        case "ne":
            y += 0.5
            ++x
            break
        case "se":
            y -= 0.5
            ++x
            break
        case "s":
            --y
            break
        case "sw":
            y -= 0.5
            --x
            break
        case "nw":
            y += 0.5
            --x
            break
        default:
            print "DATA ERROR, unrecognized direction", $i
            exit _exit=1
        }
        if (DEBUG) {
            print "after", $i, "y =", y, "x =", x
        }
    }
    y = (y > 0) ? y : -y
    x = (x > 0) ? x : -x
    if (DEBUG) {
        print "after normalization", "y =", y, "x =", x
    }
    y -= (x / 2)
    print (y > 0) ? x + y : x
}
END {
    if (_exit) {
        exit _exit
    }
}
