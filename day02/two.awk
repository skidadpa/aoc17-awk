#!/usr/bin/env awk -f
BEGIN {
    spreadsheet_checksum = 0
    DEBUG = 1
}
($0 !~ /^[[:digit:]]+([[:space:]]+[[:digit:]]+)*$/) {
    print "DATA ERROR"
    exit _exit=1
}
{
    result = 0
    for (i = 1; i < NF; ++i) {
        if ($i == 0) {
            continue
        }
        for (j = i + 1; j <= NF; ++j) {
            if ($j == 0) {
                continue
            }
            quotient = ($i > $j) ? ($i / $j) : ($j / $i)
            if (quotient == int(quotient)) {
                if (result) {
                    print "PROCESSING ERROR: multiple numbers divide evenly"
                    exit _exit=1
                }
                result = quotient
            }
        }
    }
    row_checksum = result
    spreadsheet_checksum += row_checksum
}
END {
    if (_exit) {
        exit _exit
    }
    print spreadsheet_checksum
}
