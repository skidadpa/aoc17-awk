#!/usr/bin/env awk -f
BEGIN {
    valid_passphrases = 0
    DEBUG = 1
}
{
    split("", WORDS)
    valid = 1
    for (i = 1; i <= NF; ++i) {
        if ($i in WORDS) {
            valid = 0
            break
        } else {
            WORDS[$i] = 1
        }
    }
    valid_passphrases += valid
}
END {
    if (_exit) {
        exit _exit
    }
    print valid_passphrases
}
