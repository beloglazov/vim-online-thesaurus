" Vim plugin for looking up words in an online thesaurus
" Author:       Anton Beloglazov <http://beloglazov.info/>
" Version:      0.1
" Original idea and code: Nick Coleman <http://www.nickcoleman.org/>

if exists("g:loaded_online_thesaurus")
    finish
endif
let g:loaded_online_thesaurus = 1

let s:save_cpo = &cpo
set cpo&vim

let s:path = expand("<sfile>:p:h")

function! s:Lookup()
    let s:word = expand('<cword>')
    silent keepalt belowright split thesaurus
    setlocal noswapfile nobuflisted nospell nowrap modifiable
    setlocal buftype=nofile bufhidden=hide
    1,$d
    echo "Requesting thesaurus.com to look up the word \"" . s:word . "\"..."
    exec ":silent 0r !" . s:path . "/thesaurus-lookup.sh " . s:word
    normal! Vgqgg
    exec 'resize ' . (line('$') - 1)
    setlocal nomodifiable filetype=thesaurus
    nnoremap <silent> <buffer> q :q<CR>
endfunction

if !exists('g:online_thesaurus_map_keys')
    let g:online_thesaurus_map_keys = 1
endif

if g:online_thesaurus_map_keys
    nnoremap <unique> <LocalLeader>K :call <SID>Lookup()<CR>
endif

command! OnlineThesaurusLookup :call <SID>Lookup()

let &cpo = s:save_cpo
