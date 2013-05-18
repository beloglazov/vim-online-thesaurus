#!/bin/bash

wget -q http://thesaurus.com/browse/${1} -O src.tmp
echo -n "Main entry: "
cat src.tmp | \
    grep 'queryn' | \
    sed -n -e 's/.*b>\(.*\)<\/b>.*/\1/p'
echo -n "Definition: "
cat src.tmp | \
    grep -m2 -A1 'Definition' | \
    sed -n -e 's/<td>\(.*\)<\/td.*/\1/p'
echo -n "Synonyms: "
cat src.tmp | \
    sed -n '/<td valign="top">Synonyms:<\/td>/,/\/span/ {/\/span/q; p;}' | \
    sed 's/.*<td.*//g' | \
    sed 's/<[^>]*>//g' | \
    tr -d '*' | \
    tr '\n' ' ' | \
    sed -e 's/^ *//' | \
    sed -e 's/ *$//'
rm src.tmp

