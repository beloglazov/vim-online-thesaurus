#!/usr/bin/env sh

# Vim plugin for looking up words in an online thesaurus
# Author:       Anton Beloglazov <http://beloglazov.info/>
# Version:      0.3.2
# Original idea and code: Nick Coleman <http://www.nickcoleman.org/>

URL="http://www.thesaurus.com/browse/$(echo $1 | tr ' ' '+')"

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
    awk -F'<|>|&quot;' '/synonym-description">/,/filter-[0-9]+/ {
        if (index($0, "txt\">"))
            printf "\nDefinition: %s", $3
        else if (index($0, "ttl\">"))
            printf " %s\nSynonyms:\n", $3
        else if (index($0, "thesaurus.com")) {
            sub(/-/, " ", $7)
            printf "%s %s\n", $7, $15
        }
    } /container-info antonyms/,/\/section/ {
        if (index($0, "container-info antonyms"))
            print "\nAntonyms:"
        else if (index($0, "thesaurus.com/browse")) {
            sub(/--/, " ", $7)
            printf "%s %s\n", $7, $15
        }
    }' "$OUTFILE"
else
    echo "The word \"${1}\" has not been found on thesaurus.com!"
fi

rm "$OUTFILE"
