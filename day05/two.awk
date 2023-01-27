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
        if (DEBUG) {
            for (i in JUMPS) {
                if (i == pc) {
                    printf("(%3d)", JUMPS[i])
                } else {
                    printf(" %3d ", JUMPS[i])
                }
            }
            printf("\n")
        }
        next_pc = pc + JUMPS[pc]
        if (JUMPS[pc] < 3) {
            ++JUMPS[pc]
        } else {
            --JUMPS[pc]
        }
        ++instruction_count
    }
    if (DEBUG) {
        for (i in JUMPS) {
            printf(" %3d ", JUMPS[i])
        }
        printf("\n")
    }
    print instruction_count
}
