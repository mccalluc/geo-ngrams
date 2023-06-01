#!/usr/bin/env bash
set -o errexit

info() {
    echo '  already done'
}

export PYTHONIOENCODING='latin_1'
cd cache

echo 'download...'
ZIP=DomesticNames_AllStates_Text.zip
URL="https://prd-tnm.s3.amazonaws.com/StagedProducts/GeographicNames/DomesticNames/$ZIP"
if [ -e "$ZIP" ]; then
    info
else
    wget $URL
fi

echo 'parse...'
GEONAMES='1-geonames.tsv'
if [ -e "$GEONAMES" ]; then
    info
else
    unzip -p "$ZIP" | ../scripts/parse-gnis.py  > "$GEONAMES"
fi

echo 'unique...'
UNIQUE='2-unique-words.txt'
if [ -e "$UNIQUE" ]; then
    info
else
    cat "$GEONAMES" | ../scripts/find-unique.py > "$UNIQUE"
fi

echo 'filter...'
FILTERED='3-filtered.tsv'
if [ -e "$FILTERED" ]; then
    info
else
    cat "$GEONAMES" | ../scripts/filter.py "$UNIQUE" > "$FILTERED"
fi

echo 'count...'
COUNTS='4-count-buckets.json'
if [ -e "$COUNTS" ]; then
    info
else
    cat "$FILTERED" | ../scripts/count.py > "$COUNTS"
fi

echo 'norm...'
NORMS='5-norm-buckets.json'
if [ -e "$NORMS" ]; then
    info
else
    cat "$COUNTS" | ../scripts/norm.py > "$NORMS"
fi
