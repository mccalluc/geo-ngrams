#!/usr/bin/env python3
from sys import stdin, argv
from csv import DictReader
from pathlib import Path
from json import loads


bbox = loads(Path(argv[1]).read_text())['bbox']
min_long, min_lat, max_long, max_lat = bbox


cols = ["feature_name", "feature_class", "state_name", "prim_lat_dec", "prim_long_dec"]
print("\t".join(cols))

for row in DictReader((line.replace("\0","").replace("\r","") for line in stdin), delimiter="|"):
    if row["feature_class"] != "Stream":
        continue
    lat = float(row['prim_lat_dec'])
    long = float(row['prim_long_dec'])
    if lat > max_lat or long > max_long:
        continue
    if lat < min_lat or long < min_long:
        continue
    print("\t".join([row[col] for col in cols]))