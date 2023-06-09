#!/usr/bin/env python3
from sys import stdin, argv
from json import loads, dumps

geo = loads(''.join(stdin.readlines()))
new_features = []
for feature in geo['features']:
    if feature['properties']['NAME'] not in argv[1:]:
        new_features.append(feature)
geo['features'] = new_features

print(dumps(geo))