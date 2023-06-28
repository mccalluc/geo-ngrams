# geo-ngrams

Different regions have distinctive patterns in their place names,
even if we limit ourselves to looking at letter or bigram frequencies.
This is a [set of visualizations](https://mccalluc.github.io/geo-ngrams) that help identify the distinctive ngrams of a few different regions,
and a set of scripts which could be a starting point for extending the analysis to other parts of the world.

## Pipeline outline

- Download a list of placenames
- Filter it
  - by feature type: For the US, I am only using river names
  - by uniqueness: For the US, I only retain words that are unique to a single state
- Bucket the names in a latitude-longitude grid
- For each square in the grid
  - count the occurences of each ngram
  - and calculate the ratio of this count to the counts across the whole set
- Filter out ngrams
  - whose frequency is low
  - or whose ratio to the whole set is low

What remains are lat-long buckets of bigrams that met a minimum count threshold,
and which are more frequent in a particular bucket than elsewhere.

## Development

The pipeline populates the git-ignored `cache/` directory,
and copies the final JSON into `docs/`.

From a fresh checkout, install dependencies for the pipeline:
```
npm install
```

Then run the pipeline:
```
pipeline.sh
```

Then install dependencies and start jekyll:
```
cd docs
bundle install
bundle exec jekyll serve
```
