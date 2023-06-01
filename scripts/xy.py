#!/usr/bin/env python3
from sys import argv
from json import loads, dumps
from pathlib import Path
from math import log2

norm_buckets = loads(Path(argv[1]).read_text())
count_buckets = loads(Path(argv[2]).read_text())

xy_buckets = {
    bucket_name: {
        bigram: [round(log2(norm), 3), count]
        for bigram, norm in norm_bigrams.items()
        if (count := count_buckets[bucket_name][bigram]) > 10 # At least 10 occurrences,
        and (log_change := round(log2(norm))) > 1 # and at least double the norm.
    }
    for bucket_name, norm_bigrams in norm_buckets.items()
}

print(
    dumps(xy_buckets, indent=0, sort_keys=True)
    .replace('[\n', '[')
    .replace('\n]', ']')
    .replace(',\n"', ', \n"')
    .replace(',\n', ', ')
)