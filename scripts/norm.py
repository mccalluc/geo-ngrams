#!/usr/bin/env python3
from sys import stdin
from collections import Counter
from json import loads, dumps


def norm_counter(counter):
    '''
    Returns a dict whose values sum to 1,
    but are still in the same ratios as the provided counter.
    '''
    total = sum(counter.values())
    return {k: v/total for k, v in counter.items()}


def ratio_counter(a, b):
    '''
    Returns a dict whose values are a ratio
    of the respective values in a and b.
    '''
    return {k: v / b[k] for k, v in a.items()}


counters = loads(''.join(stdin.readlines()))
total = Counter()
for counter in counters.values():
    total += counter
norm_total = norm_counter(total)

norm_counters = {k: norm_counter(v) for k, v in counters.items()}
ratio_counters = {k: ratio_counter(v, norm_total) for k, v in norm_counters.items()}

print(dumps(ratio_counters, indent=2))