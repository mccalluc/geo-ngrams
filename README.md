# geo-bigrams
Mapping place-name bigrams to uncover linguistic diversity

Deployed on [github pages](https://mccalluc.github.io/geo-bigrams)

## Developement

A pipeline populates the git-ignored `cache/` directory,
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
