#!/usr/bin/env bash
set -o errexit

cd cache
ZIP=DomesticNames_AllStates_Text.zip

URL="https://prd-tnm.s3.amazonaws.com/StagedProducts/GeographicNames/DomesticNames/$ZIP"
[ -e "$ZIP" ] || wget $URL

export PYTHONIOENCODING='latin_1'
unzip -p "$ZIP" | python -c '
from sys import stdin
from csv import DictReader

for row in DictReader((line.replace("\0","").replace("\r","") for line in stdin), delimiter="|"):
    if row["state_name"] in ["state_name", "Alaska", "Hawaii"]:
        continue
    if row["feature_class"] != "Stream":
        continue
    print("\t".join([row["feature_name"], row["feature_class"], row["state_name"], row["prim_lat_dec"], row["prim_long_dec"]]))
' > streams.tsv
