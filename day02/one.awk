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
    smallest = largest = 0
    for (i = 1; i <= NF; ++i) {
        if (!smallest || ($smallest > $i)) {
            smallest = i
        }
        if (!largest || ($largest < $i)) {
            largest = i
        }
    }
    row_checksum = $largest - $smallest
    spreadsheet_checksum += row_checksum
}
END {
    if (_exit) {
        exit _exit
    }
    print spreadsheet_checksum
}
