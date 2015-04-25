" Vim plugin for looking up words in an online thesaurus
" Author:       Anton Beloglazov <http://beloglazov.info/>
" Version:      0.2.2
" Original idea and code: Nick Coleman <http://www.nickcoleman.org/>

if exists("g:loaded_online_thesaurus")
    finish
endif
let g:loaded_online_thesaurus = 1

let s:save_cpo = &cpo
set cpo&vim
let s:save_shell = &shell
let &shell = '/bin/sh'

let s:path = shellescape(expand("<sfile>:p:h"))

silent let s:sort = system('if command -v /bin/sort > /dev/null; then'
            \ . ' printf /bin/sort;'
            \ . ' else printf sort; fi')

function! s:Lookup(word)
    if bufexists('thesaurus')
        let thesaurus_window = bufwinnr('^thesaurus$')
        exec thesaurus_window . "wincmd w"
    else
        silent keepalt belowright split thesaurus
    endif

    setlocal noswapfile nobuflisted nospell nowrap modifiable
    setlocal buftype=nofile bufhidden=hide
    let l:word = substitute(a:word, '"', '', 'g')
    1,$d
    echo "Requesting thesaurus.com to look up the word \"" . l:word . "\"..."
    exec ":silent 0r !" . s:path . "/thesaurus-lookup.sh " . shellescape(l:word)
    exec ":silent g/\\vrelevant-\\d+/,/^$/!" . s:sort . " -t ' ' -k 1,1r -k 2,2"
    silent g/\vrelevant-\d+ /s///
    silent! g/^Synonyms/+;/^$/-2s/$\n/, /
    silent g/^Synonyms:/ normal! JVgq
    0
    exec 'resize ' . (line('$') - 1)
    setlocal nomodifiable filetype=thesaurus
    nnoremap <silent> <buffer> q :q<CR>
endfunction

if !exists('g:online_thesaurus_map_keys')
    let g:online_thesaurus_map_keys = 1
endif

if g:online_thesaurus_map_keys
    nnoremap <unique> <LocalLeader>K :OnlineThesaurusCurrentWord<CR>
endif

command! OnlineThesaurusCurrentWord :call <SID>Lookup(expand('<cword>'))
command! OnlineThesaurusLookup :call <SID>Lookup(expand('<cword>'))
command! -nargs=1 Thesaurus :call <SID>Lookup(<q-args>)

let &cpo = s:save_cpo
let &shell = s:save_shell
