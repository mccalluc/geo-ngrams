#!/usr/bin/env python3
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