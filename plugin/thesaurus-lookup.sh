#!/usr/bin/env sh

# Vim plugin for looking up words in an online thesaurus
# Author:       Anton Beloglazov <http://beloglazov.info/>
# Version:      0.2.1
# Original idea and code: Nick Coleman <http://www.nickcoleman.org/>

URL="http://www.thesaurus.com/browse/${1/ /+}"

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

if ! grep -q 'no thesaurus results' "$OUTFILE" && grep -q 'html' "$OUTFILE"; then
    printf "%s" 'Main entry: '
    echo ${1} | tr '[A-Z]' '[a-z]'

    awk -F'<|>|&quot;' '/synonym-description">/,/filter-[0-9]+/ {
        if (index($0, "txt\">"))
            printf "\nDefinition: %s", $3
        else if (index($0, "ttl\">"))
            printf " %s\nSynonyms:\n", $3
        else if (index($0, "thesaurus.com"))
            printf "%s ", $5
        else if (index($0, "text\">"))
            print $3
    }' "$OUTFILE"
else
    echo "The word \"${1}\" has not been found on thesaurus.com!"
fi

rm "$OUTFILE"
