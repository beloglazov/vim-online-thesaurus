#!/bin/sh

mkdir vim-online-thesaurus
cp -r README.md vim-online-thesaurus
cp -r doc vim-online-thesaurus
cp -r plugin vim-online-thesaurus
cp -r syntax vim-online-thesaurus

tar czf vim-online-thesaurus.tar.gz vim-online-thesaurus
rm -rf vim-online-thesaurus

