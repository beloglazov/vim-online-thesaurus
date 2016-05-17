" Vim plugin for looking up words in an online thesaurus
" Author:       Anton Beloglazov <http://beloglazov.info/>
" Version:      0.3.2
" Original idea and code: Nick Coleman <http://www.nickcoleman.org/>

if exists("b:current_syntax")
    finish
endif

" Setup
syntax case match
setlocal iskeyword+=:

" Entry name rules
syntax keyword thesDefinition Definition:
syntax keyword thesSynonyms Synonyms:
syntax match thesPartOfSpeech '\v\a{,6}\.'

" Entry contents rules

" Highlighting
hi link thesDefinition  Keyword
hi link thesSynonyms    Keyword
hi thesPartOfSpeech     term=italic cterm=italic gui=italic

let b:current_syntax = "thesaurus"
