#!/usr/bin/env python3
from sys import stdin, argv
from csv import DictReader
from pathlib import Path

unique_words = set(Path(argv[1]).read_text().splitlines())

cols = ["unique_word", "feature_name", "feature_class", "state_name", "prim_lat_dec", "prim_long_dec"]
print("\t".join(cols))

for row in DictReader(stdin, delimiter="\t"):
    words = row["feature_name"].split(" ")
    row_unique_words = [word for word in words if word in unique_words]
    if row_unique_words:
        row["unique_word"] = ''.join(row_unique_words).lower()  # Possible that there are multiple, but that's uncommon.
        print("\t".join([row[col] for col in cols]))
