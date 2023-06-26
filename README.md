# geo-bigrams
Mapping place-name bigrams to uncover linguistic diversity

Deployed on [github pages](https://mccalluc.github.io/geo-bigrams)

## Developement

A pipeline populates the git-ignored `cache/` directory,
and as a last step copies the final JSON into `docs/`.

From a fresh checkout:
- `pipeline.sh`
- `bundle install`
- `bundle exec jekyll serve`
