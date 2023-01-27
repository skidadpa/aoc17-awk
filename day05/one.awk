#!/usr/bin/env awk -f
BEGIN {
    DEBUG = 0
}
($0 !~ /^-?[[:digit:]]+$/) {
    print "DATA ERROR"
    exit _exit=1
}
{
    JUMPS[NR] = int($1)
}
END {
    if (_exit) {
        exit _exit
    }
    for (pc = 1; pc in JUMPS; pc = next_pc) {
        next_pc = pc + JUMPS[pc]
        ++JUMPS[pc]
        ++instruction_count
    }
    print instruction_count
}
