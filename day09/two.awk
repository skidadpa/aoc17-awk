#!/usr/bin/env awk -f
BEGIN {
    FS = ""
    DEBUG = 1
}
{
    escaping = garbage = count = 0
    for (i = 1; i <= NF; ++i) {
        if (escaping) {
            escaping = 0
            continue
        }
        switch ($i) {
        case "!":
            escaping = 1
            break
        case "<":
            if (garbage) {
                ++count
            }
            garbage = 1
            break
        case ">":
            garbage = 0
            break
        default:
            if (garbage) {
                ++count
            }
            break
        }
    }
    print count
}
END {
    if (_exit) {
        exit _exit
    }
}
