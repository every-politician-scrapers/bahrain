#!/bin/bash

cd $(dirname $0)

# scraped.csv generated manually from source

wd sparql -f csv wikidata.js | sed -e 's/T00:00:00Z//g' -e 's#http://www.wikidata.org/entity/##g' | qsv dedup -s psid > wikidata.csv

# Ignore anyone in the Cabinet but not in the article
# We only care that everyone in the article is in the Cabinet
bundle exec ruby diff.rb | qsv sort -s itemlabel | qsv search -v '\-\-\-' | tee diff.csv

cd ~-
