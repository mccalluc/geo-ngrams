#!/usr/bin/env bash
set -o errexit
set -o xtrace

info() {
    echo '  already done'
}

# npm install
export PYTHONIOENCODING='latin_1'
mkdir cache || echo 'cache already exists'
cd cache


# Geography:

echo 'geo...'
GEO='gz_2010_us_040_00_20m.json'
if [ -e "$GEO" ]; then
    info
else
    wget "https://eric.clst.org/assets/wiki/uploads/Stuff/$GEO"
fi

echo 'filter...'
FILTERED_GEO='filtered.json'
if [ -e "$FILTERED_GEO" ]; then
    info
else
    cat "$GEO" | ../scripts/filter-geo.py 'Alaska' 'Hawaii' > "$FILTERED_GEO"
fi

echo 'topo...'
TOPO='full-topo.json'
if [ -e "$TOPO" ]; then
    info
else
    ../node_modules/topojson-server/bin/geo2topo --quantization 1000 states="$FILTERED_GEO" > "$TOPO"
fi

echo 'simple...'
SIMPLE='topo.json'
if [ -e "$SIMPLE" ]; then
    info
else
    ../node_modules/topojson-simplify/bin/toposimplify --planar-quantile 0.05  "$TOPO" > "$SIMPLE"
fi

echo 'cp topo...'
DOCS_TOPO="../docs/data/$SIMPLE"
cp "$SIMPLE" "$DOCS_TOPO"

# ngrams:

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

echo 'xy...'
XY='6-xy-buckets.json'
if [ -e "$XY" ]; then
    info
else
    ../scripts/xy.py "$NORMS" "$COUNTS" > "$XY"
fi

echo 'cp ngrams...'
JSON='../docs/data/ngrams.json'
if [ -e "$JSON" ]; then
    info
else
    cp "$XY" "$JSON"
fi
