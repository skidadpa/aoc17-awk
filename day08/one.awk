#!/usr/bin/env awk -f
BEGIN {
    DEBUG = 0
}
/^[[:lower:]]+ ((inc)|(dec)) -?[[:digit:]]+ if [[:lower:]]+ < -?[[:digit:]]+$/ {
    if (REGISTER[$5] < int($7)) {
        REGISTER[$1] += int(($2 == "inc") ? $3 : -$3)
    }
    next
}
/^[[:lower:]]+ ((inc)|(dec)) -?[[:digit:]]+ if [[:lower:]]+ <= -?[[:digit:]]+$/ {
    if (REGISTER[$5] <= int($7)) {
        REGISTER[$1] += int(($2 == "inc") ? $3 : -$3)
    }
    next
}
/^[[:lower:]]+ ((inc)|(dec)) -?[[:digit:]]+ if [[:lower:]]+ == -?[[:digit:]]+$/ {
    if (REGISTER[$5] == int($7)) {
        REGISTER[$1] += int(($2 == "inc") ? $3 : -$3)
    }
    next
}
/^[[:lower:]]+ ((inc)|(dec)) -?[[:digit:]]+ if [[:lower:]]+ != -?[[:digit:]]+$/ {
    if (REGISTER[$5] != int($7)) {
        REGISTER[$1] += int(($2 == "inc") ? $3 : -$3)
    }
    next
}
/^[[:lower:]]+ ((inc)|(dec)) -?[[:digit:]]+ if [[:lower:]]+ >= -?[[:digit:]]+$/ {
    if (REGISTER[$5] >= int($7)) {
        REGISTER[$1] += int(($2 == "inc") ? $3 : -$3)
    }
    next
}
/^[[:lower:]]+ ((inc)|(dec)) -?[[:digit:]]+ if [[:lower:]]+ > -?[[:digit:]]+$/ {
    if (REGISTER[$5] > int($7)) {
        REGISTER[$1] += int(($2 == "inc") ? $3 : -$3)
    }
    next
}
{
    print "DATA ERROR, unrecognized instruction", $0
    exit _exit=1
}
END {
    if (_exit) {
        exit _exit
    }
    for (r in REGISTER) {
        if (!largest || (REGISTER[largest] < REGISTER[r])) {
            largest = r
        }
    }
    if (DEBUG) {
        printf("Largest register %s = ", largest)
    }
    print REGISTER[largest]
}
