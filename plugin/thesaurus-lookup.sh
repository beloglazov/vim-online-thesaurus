#!/usr/bin/env sh

# Vim plugin for looking up words in an online thesaurus
# Author:       Anton Beloglazov <http://beloglazov.info/>
# Version:      0.1.8
# Original idea and code: Nick Coleman <http://www.nickcoleman.org/>

URL="http://www.thesaurus.com/browse/${1}"

if [ "$(uname)" = "FreeBSD" ]; then
        DOWNLOAD="fetch"
        OPTIONS="-qo"
elif command -v curl > /dev/null; then
        DOWNLOAD="curl"
        OPTIONS="-so"
elif command -v wget > /dev/null; then
        DOWNLOAD="wget"
        OPTIONS="-qO"
else
        echo "FreeBSD fetch, curl, or wget not found"
        exit 1
fi

if command -v mktemp > /dev/null; then
        OUTFILE="$(mktemp /tmp/XXXXXXX)"
else
        NEW_RAND="$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | head -c 12)"
        touch /tmp/$NEW_RAND
        OUTFILE="/tmp/$NEW_RAND"
fi

"$DOWNLOAD" "$OPTIONS" "$OUTFILE" "$URL"

if ! grep -q 'no thesaurus results' "$OUTFILE"; then
    printf "%s" 'Main entry: '
    echo ${1} | tr '[A-Z]' '[a-z]'

    printf "%s" 'Definition: '
    awk -F'<|>' '/layer disabled/ {flag=0}; \
        flag && /ttl/ {print $3; flag=0}; \
        /words-gallery/ {flag=1}' "$OUTFILE"

    printf "%s" 'Synonyms: '
    awk -F'<|>|&quot;' 'flag && /<\/div>/ {flag=0; done=1}; \
        flag && !done && /thesaurus.com/ {printf "%s ",$5}; \
        flag && !done && /text/ {print $3}; \
        /relevancy-list/ {flag=1}' "$OUTFILE" | \
        /bin/sort -t ' ' -k 1,1r -k 2,2 | \
        sed 's/relevant-[0-9]* //g' | \
        sed 's/$/, /g' | \
        tr -d '\n' | \
        sed 's/, *$//' | \
        tr -d '\n'
else
    echo "The word \"${1}\" has not been found on thesaurus.com!"
fi

rm "$OUTFILE"
