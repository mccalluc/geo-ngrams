#!/usr/bin/env python3
from sys import stdin, argv
from csv import DictReader
from collections import defaultdict, Counter
from math import floor
from json import dumps



def parse_round(x, r=1):
    # Rounds to the center of the interval
    return (floor(float(x) / r) + 0.5) * r

def make_bucket_name(lat, long):
    return f'{parse_round(lat, 5)},{parse_round(long, 5)}'


count_buckets = defaultdict(lambda: {'total': 0, 'ngrams': Counter()})

for row in DictReader(stdin, delimiter="\t"):
    bucket_name = make_bucket_name(row["prim_lat_dec"], row["prim_long_dec"])
    word = row["unique_word"]
    ngrams = [f'{a}{b}' for a, b in zip(f'^{word}', f'{word}$')]
    count_buckets[bucket_name]['total'] += 1
    count_buckets[bucket_name]['ngrams'] += Counter(ngrams)

ratio_buckets = {}

for coords, total_ngrams in count_buckets.items():
    total = total_ngrams['total']
    ngrams = total_ngrams['ngrams']
    ratio_buckets[coords] = {ngram: count / total for ngram, count in ngrams.items()}


print(dumps(ratio_buckets, indent=2))