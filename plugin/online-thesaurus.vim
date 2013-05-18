" online-thesaurus.vim - Online Thesaurus Lookups
" Author:       Anton Beloglazov <http://beloglazov.info/>
" Version:      0.1
" Original idea and code: Nick Coleman <http://www.nickcoleman.org/>

fun! OnlineThesaurusLookup()
   " Assign current word under cursor to a script variable
   let s:thes_word = expand('<cword>')
   " Open a new window, keep the alternate so this doesn't clobber it.
   keepalt split thes_
   " Show cursor word in status line
   exe "setlocal statusline=" . s:thes_word
   " Set buffer options for scratch buffer
   setlocal noswapfile nobuflisted nowrap nospell
     \buftype=nofile bufhidden=hide
   " Delete existing content
   1,$d
   " Run the thesaurus script
   exe ":0r !./thesaurus-lookup.sh " . s:thes_word
   " Goto first line
   1
   " Set file type to 'thesaurus'
   set filetype=thesaurus
   " Map q to quit without confirm
   nnoremap <buffer> q :q<CR>
endfun

if !exists('g:online_thesaurus_map_keys')
    let g:online_thesaurus_map_keys = 1
endif

if g:online_thesaurus_map_keys
    nnoremap <localleader>K :call <sid>OnlineThesaurusLookup()<CR>
endif
