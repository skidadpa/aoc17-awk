#!/usr/bin/env awk -f
BEGIN {
    FPAT="[[:lower:]]+|[[:digit:]]+"
    ADD = 1
    SUB = 2
    DEBUG = 0
}
$0 !~ /^[[:lower:]]+ \([[:digit:]]+\)( -> [[:lower:]]+(, [[:lower:]]+)*)*/ {
    print "DATA ERROR"
    exit _exit=1
}
{
    WEIGHT[$1] = int($2)
    for (i = 3; i <= NF; ++i) {
        BRANCHES[$1][$i] = 1
        if ($i in SUPPORTER) {
            print "PROGRAM ERROR, interleaved branches not supported"
            exit _exit=1
        }
        SUPPORTER[$i] = $1
    }
}
function total_weights(favor, trunk,   branch, BRANCH_WEIGHTS, weight, n1, n2, b1, b2, replacing) {
    TOTAL_WEIGHT[trunk] = WEIGHT[trunk]
    if (!(trunk in BRANCHES)) {
        return TOTAL_WEIGHT[trunk]
    }
    split("", BRANCH_WEIGHTS)
    for (branch in BRANCHES[trunk]) {
        weight = total_weights(favor, branch)
        BRANCH_WEIGHTS[weight][branch] = 1
        TOTAL_WEIGHT[trunk] += weight
    }
    switch (length(BRANCH_WEIGHTS)) {
    case 1:
        break
    case 2:
        if (REPLACE_WEIGHT) {
            if (DEBUG) {
                print "TREE ERROR: additional replacement needed at", trunk
                for (branch in BRANCHES[trunk]) {
                    print WEIGHT[branch], branch, "total", TOTAL_WEIGHT[branch]
                }
            }
            TREE_ERROR = 1
            return TOTAL_WEIGHT[trunk]
        }
        for (weight in BRANCH_WEIGHTS) {
            if (!n1) {
                b1 = int(weight)
                n1 = length(BRANCH_WEIGHTS[weight])
            } else {
                b2 = int(weight)
                n2 = length(BRANCH_WEIGHTS[weight])
            }
        }
        if (DEBUG) {
            print "finding replacement at", trunk, "with", n1, "*", b1, "and", n2, "*", b2
            for (branch in BRANCHES[trunk]) {
                print WEIGHT[branch], branch, "total", TOTAL_WEIGHT[branch]
            }
        }
        if (n1 > 1) {
            if (n2 > 1) {
                if (DEBUG) {
                    print "TREE ERROR: multiple replacements needed at", trunk
                }
                TREE_ERROR = 1
                return TOTAL_WEIGHT[trunk]
            }
            replacing = b2
            REPLACE_WEIGHT = (b1 - b2)
        } else if (n2 > 1) {
            replacing = b1
            REPLACE_WEIGHT = (b2 - b1)
        } else if (favor == 1) {
            replacing = b2
            REPLACE_WEIGHT = (b1 - b2)
            REPLACED_PAIR = 1
        } else if (favor == 2) {
            replacing = b1
            REPLACE_WEIGHT = (b2 - b1)
            REPLACED_PAIR = 1
        } else {
            print "PROCESSING ERROR, unexpected inputs"
            exit _exit=1
        }
        TOTAL_WEIGHT[trunk] += REPLACE_WEIGHT
        for (branch in BRANCH_WEIGHTS[replacing]) {
            REPLACE_WEIGHT += WEIGHT[branch]
        }
        break
    default:
        if (DEBUG) {
            print "TREE ERROR:", length(BRANCH_WEIGHTS), "branch weights"
        }
        TREE_ERROR = 1
        return TOTAL_WEIGHT[trunk]
    }
    return TOTAL_WEIGHT[trunk]
}
END {
    if (_exit) {
        exit _exit
    }
    for (bottom in BRANCHES) {
        if (!(bottom in SUPPORTER)) {
            break
        }
    }
    REPLACE_WEIGHT = TREE_ERROR = 0
    delete TOTAL_WEIGHT
    total_weights(1, bottom)
    if (TREE_ERROR && REPLACED_PAIR) {
        if (DEBUG) {
            print "TREE ERROR, trying again favoring right branch of pairs"
        }
        REPLACE_WEIGHT = TREE_ERROR = 0
        delete TOTAL_WEIGHT
        total_weights(2, bottom)
    }
    if (TREE_ERROR || !REPLACE_WEIGHT) {
        print "PROCESSING ERROR, no solution found"
        exit _exit=1
    }
    print REPLACE_WEIGHT
}
