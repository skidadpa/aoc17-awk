#!/usr/bin/env awk -f
BEGIN {
    FS = "\t"
    DEBUG = 0
}
($0 !~ /^[[:digit:]]+(\t[[:digit:]]+)*$/) {
    print "DATA ERROR in", $0
    exit _exit=1
}
{
    count = 0
    blocks = $0
    if (DEBUG) {
	print "initial blocks:", blocks
    }
    while (!(blocks in CONFIGURATIONS)) {
        CONFIGURATIONS[blocks] = count++
        split(blocks, BLOCKS, "\t")
	largest = 0
	for (i = 1; i <= NF; ++i) {
	    if (!largest || (BLOCKS[largest] < BLOCKS[i])) {
		largest = i
	    }
	}
	blocks_to_redistribute = BLOCKS[largest]
	BLOCKS[largest] = 0
	i = largest
	while (blocks_to_redistribute) {
	    ++i
	    if (i > NF) {
		i = 1
	    }
	    ++BLOCKS[i]
	    --blocks_to_redistribute
	}
	blocks = BLOCKS[1]
	for (i = 2; i <= NF; ++i) {
	    blocks = blocks "\t" BLOCKS[i]
	}
	if (DEBUG) {
	    print "after", count, "cycles:", blocks
	}
    }
    print count - CONFIGURATIONS[blocks]
}
END {
    if (_exit) {
        exit _exit
    }
}
