#!/usr/bin/env bash
set -o errexit

cd cache
ZIP=DomesticNames_AllStates_Text.zip

echo 'download...'

URL="https://prd-tnm.s3.amazonaws.com/StagedProducts/GeographicNames/DomesticNames/$ZIP"
[ -e "$ZIP" ] || wget $URL

export PYTHONIOENCODING='latin_1'

echo 'parse...'

STREAMS='streams.tsv'
[ -e "$STREAMS" ] || unzip -p "$ZIP" | python -c '
from sys import stdin
from csv import DictReader

cols = ["feature_name", "feature_class", "state_name", "prim_lat_dec", "prim_long_dec"]
print("\t".join(cols))

states = set([
  "Alabama",
  "Arizona",
  "Arkansas",
  "California",
  "Colorado",
  "Connecticut",
  "Delaware",
  "District of Columbia",
  "Florida",
  "Georgia",
  "Idaho",
  "Illinois",
  "Indiana",
  "Iowa",
  "Kansas",
  "Kentucky",
  "Louisiana",
  "Maine",
  "Maryland",
  "Massachusetts",
  "Michigan",
  "Minnesota",
  "Mississippi",
  "Missouri",
  "Montana",
  "Nebraska",
  "Nevada",
  "New Hampshire",
  "New Jersey",
  "New Mexico",
  "New York",
  "North Carolina",
  "North Dakota",
  "Ohio",
  "Oklahoma",
  "Oregon",
  "Pennsylvania",
  "Rhode Island",
  "South Carolina",
  "South Dakota",
  "Tennessee",
  "Texas",
  "Utah",
  "Vermont",
  "Virginia",
  "Washington",
  "West Virginia",
  "Wisconsin",
  "Wyoming"
])

for row in DictReader((line.replace("\0","").replace("\r","") for line in stdin), delimiter="|"):
    if row["state_name"] in ["state_name", "Alaska", "Hawaii"]:
        continue
    if row["state_name"] not in states:
        continue
    if row["feature_class"] != "Stream":
        continue
    print("\t".join([row[col] for col in cols]))
' > "$STREAMS"

echo 'unique...'

UNIQUE='unique-words.txt'
[ -e "$UNIQUE" ] || cat "$STREAMS" | python -c '
from sys import stdin
from csv import DictReader
from collections import defaultdict

word_states = defaultdict(set)

for row in DictReader(stdin, delimiter="\t"):
    state = row["state_name"]
    words = row["feature_name"].split(" ")
    for word in words:
        word_states[word].add(state)

for word, states in word_states.items():
    if len(states) == 1:
        print(word)
' > "$UNIQUE"



