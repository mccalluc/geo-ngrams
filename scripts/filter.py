#!/usr/bin/env python3
from sys import stdin, argv
from csv import DictReader
from pathlib import Path

unique_words = set(Path(argv[1]).read_text().splitlines())

cols = ["feature_name", "feature_class", "state_name", "prim_lat_dec", "prim_long_dec"]
print("\t".join(cols))

for row in DictReader(stdin, delimiter="\t"):
    words = row["feature_name"].split(" ")
    if any(word in unique_words for word in words):
        print("\t".join([row[col] for col in cols]))
