#!/usr/bin/env python3
from sys import stdin, argv
from csv import DictReader
from collections import defaultdict, Counter
from json import dumps

cols = ["unique_word", "feature_name", "feature_class", "state_name", "prim_lat_dec", "prim_long_dec"]

buckets = defaultdict(Counter)

def parse_round(x, r=1):
    return int(float(x) / r) * r

def make_bucket_name(lat, long):
    return f'{{"lat":{parse_round(lat, 5)},"long":{parse_round(long, 5)}}}'

for row in DictReader(stdin, delimiter="\t"):
    bucket_name = make_bucket_name(row["prim_lat_dec"], row["prim_long_dec"])
    word = row["unique_word"]
    bigrams = [f'{a}{b}' for a, b in zip(f'^{word}', f'{word}$')]
    buckets[bucket_name] += Counter(bigrams)

print(dumps(buckets, indent=2))