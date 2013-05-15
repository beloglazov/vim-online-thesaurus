#!/bin/sh

# http://www.nickcoleman.org/blog/index.cgi?post=vim-thesaurus!201202170802!general%2Cblogging%2Cinternet%2Cprogramming%2Csoftware%2Cunix

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
    sed -ne 's/.*>\(.*\)<\/a>,.*/\1/p'
rm src.tmp

