#!/bin/bash

# Vim plugin for looking up words in an online thesaurus
# Author:       Anton Beloglazov <http://beloglazov.info/>
# Version:      0.1
# Original idea and code: Nick Coleman <http://www.nickcoleman.org/>

wget -q http://thesaurus.com/browse/${1} -O src.tmp

if cat src.tmp | grep 'queryn' > /dev/null; then
    echo -n 'Main entry: '
    cat src.tmp | \
        grep 'queryn' | \
        sed -n -e 's/.*b>\(.*\)<\/b>.*/\1/p'

    echo -n 'Definition: '
    cat src.tmp | \
        grep -m2 -A1 'Definition' | \
        sed -n -e 's/<td>\(.*\)<\/td.*/\1/p'

    echo -n 'Synonyms: '
    cat src.tmp | \
        sed -n '/<td valign="top">Synonyms:<\/td>/,/\/span/ {/\/span/q; p;}' | \
        sed 's/.*<td.*//g' | \
        sed 's/<[^>]*>//g' | \
        tr -d '*' | \
        tr '\n' ' ' | \
        sed -e 's/^ *//' | \
        sed -e 's/ *$//'
else
    echo "The word \"${1}\" has not been found on thesaurus.com!"
fi

rm src.tmp

