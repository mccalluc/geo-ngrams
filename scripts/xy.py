#!/usr/bin/env python3
from sys import argv
from json import loads, dumps
from pathlib import Path
from math import log2
from itertools import chain

norm_buckets = loads(Path(argv[1]).read_text())
count_buckets = loads(Path(argv[2]).read_text())

# TODO: Is there a vega transform we can use instead of this flat, redundant data structure?
# (For now, I'm more comfortable doing the transform with python, even if the result is inefficient.)
data = []
for bucket_name, norm_ngrams in norm_buckets.items():
    data += [
        {
            'norm': round(log2(norm), 3),
            'count': count,
            'ngram': ngram,
            'lat': (ll := loads(bucket_name))['lat'],
            'long': ll['long'],
        }
        for ngram, norm in norm_ngrams.items()
        if (count := count_buckets[bucket_name][ngram]) > 10 # At least 10 occurrences,
            and (log_change := round(log2(norm))) > 1 # and at least double the norm.
    ]

print(
    dumps(data, indent=0)
    .replace('[\n', '[')
    .replace('\n]', ']')
    .replace(',\n"', ', \n"')
    .replace(',\n', ', ')
)