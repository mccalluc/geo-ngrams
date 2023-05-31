#!/usr/bin/env bash
set -o errexit

cd cache
ZIP=DomesticNames_AllStates_Text.zip

echo 'download...'

URL="https://prd-tnm.s3.amazonaws.com/StagedProducts/GeographicNames/DomesticNames/$ZIP"

if [ -e "$ZIP" ]; then
    echo '  already done'
else
    wget $URL
fi


export PYTHONIOENCODING='latin_1'

echo 'parse...'

STREAMS='streams.tsv'
if [ -e "$STREAMS" ]; then
    echo '  already done'
else
    unzip -p "$ZIP" | ../scripts/parse-gnis.py  > "$STREAMS"
fi

echo 'unique...'

UNIQUE='unique-words.txt'
if [ -e "$UNIQUE" ]; then
    echo '  already done'
else
    cat "$STREAMS" | ../scripts/find-unique.py > "$UNIQUE"
fi




