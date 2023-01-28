#!/usr/bin/env awk -f
BEGIN {
    largest_val = 0
}
function update_register(r, op, val) {
    REGISTER[r] += (op == "inc") ? val : -val
    if (largest_val < REGISTER[r]) {
        largest_val = REGISTER[r]
    }
}
/^[[:lower:]]+ ((inc)|(dec)) -?[[:digit:]]+ if [[:lower:]]+ < -?[[:digit:]]+$/ {
    if (REGISTER[$5] < int($7)) {
        update_register($1, $2, int($3))
    }
    next
}
/^[[:lower:]]+ ((inc)|(dec)) -?[[:digit:]]+ if [[:lower:]]+ <= -?[[:digit:]]+$/ {
    if (REGISTER[$5] <= int($7)) {
        update_register($1, $2, int($3))
    }
    next
}
/^[[:lower:]]+ ((inc)|(dec)) -?[[:digit:]]+ if [[:lower:]]+ == -?[[:digit:]]+$/ {
    if (REGISTER[$5] == int($7)) {
        update_register($1, $2, int($3))
    }
    next
}
/^[[:lower:]]+ ((inc)|(dec)) -?[[:digit:]]+ if [[:lower:]]+ != -?[[:digit:]]+$/ {
    if (REGISTER[$5] != int($7)) {
        update_register($1, $2, int($3))
    }
    next
}
/^[[:lower:]]+ ((inc)|(dec)) -?[[:digit:]]+ if [[:lower:]]+ >= -?[[:digit:]]+$/ {
    if (REGISTER[$5] >= int($7)) {
        update_register($1, $2, int($3))
    }
    next
}
/^[[:lower:]]+ ((inc)|(dec)) -?[[:digit:]]+ if [[:lower:]]+ > -?[[:digit:]]+$/ {
    if (REGISTER[$5] > int($7)) {
        update_register($1, $2, int($3))
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
    print largest_val
}
