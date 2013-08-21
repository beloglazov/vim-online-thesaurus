#!/usr/bin/env bash

# Vim plugin for looking up words in an online thesaurus
# Author:       Anton Beloglazov <http://beloglazov.info/>
# Version:      0.1.4
# Original idea and code: Nick Coleman <http://www.nickcoleman.org/>

curl -o src.tmp http://thesaurus.com/browse/${1} >/dev/null 2>&1

if ! grep 'no thesaurus results' src.tmp > /dev/null; then
    echo -n 'Main entry: '
    echo ${1} | tr '[A-Z]' '[a-z]'

    echo -n 'Definition: '
    awk -F'<|>' '/layer disabled/ {flag=0}; \
        flag && /ttl/ {print $3; flag=0}; \
        /words-gallery/ {flag=1}' src.tmp

    echo -n 'Synonyms: '
    awk -F'<|>|&quot;' 'flag && /<\/div>/ {flag=0; done=1}; \
        flag && !done && /text/ {printf "%s ",$5; print $13};
        /relevancy-list/ {flag=1}' src.tmp | \
        sort -t ' ' -k 1,1r -k 2,2 | \
        sed 's/relevant-[0-9]* //g' | \
        sed 's/$/, /g' | \
        tr -d '\n' | \
        sed 's/, *$//' | \
        tr -d '\n'
else
    echo "The word \"${1}\" has not been found on thesaurus.com!"
fi

rm src.tmp

