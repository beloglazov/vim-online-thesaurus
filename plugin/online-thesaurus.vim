" Vim plugin for looking up words in an online thesaurus
" Author:       Anton Beloglazov <http://beloglazov.info/>
" Version:      0.3.1
" Original idea and code: Nick Coleman <http://www.nickcoleman.org/>

if exists("g:loaded_online_thesaurus")
    finish
endif
let g:loaded_online_thesaurus = 1

let s:save_cpo = &cpo
set cpo&vim
let s:save_shell = &shell
if has("win32")
    let cpu_arch      = system('echo %PROCESSOR_ARCHITECTURE%')
    let s:script_name = "\\thesaurus-lookup.sh"
    if isdirectory('C:\\Program Files (x86)\\Git')
        let &shell        = 'C:\\Program Files (x86)\\Git\\bin\\bash.exe'
        let s:sort        = "C:\\Program Files (x86)\\Git\\bin\\sort.exe"
    elseif isdirectory('C:\\Program Files\\Git')
        let &shell        = 'C:\\Program Files\\Git\\bin\\bash.exe'
        let s:sort        = "C:\\Program Files\\Git\\bin\\sort.exe"
    else
        echoerr 'vim-thesaurus: Cannot find git installation.'
    endif
else
    let &shell        = '/bin/sh'
    let s:script_name = "/thesaurus-lookup.sh"
    silent let s:sort = system('if command -v /bin/sort > /dev/null; then'
            \ . ' printf /bin/sort;'
            \ . ' else printf sort; fi')
endif

let s:path = shellescape(expand("<sfile>:p:h") . s:script_name)


function! s:Lookup(word)
    silent! let l:thesaurus_window = bufwinnr('^thesaurus$')

    if l:thesaurus_window > -1
        exec l:thesaurus_window . "wincmd w"
    else
        silent keepalt belowright split thesaurus
    endif

    setlocal noswapfile nobuflisted nospell nowrap modifiable
    setlocal buftype=nofile bufhidden=hide
    let l:word = substitute(tolower(a:word), '"', '', 'g')
    1,$d
    echo "Requesting thesaurus.com to look up the word \"" . l:word . "\"..."
    exec ":silent 0r !" . s:path . " " . shellescape(l:word)
    exec ":silent! g/\\vrelevant-\\d+/,/^$/!" . s:sort . " -t ' ' -k 1,1r -k 2,2"
    if has("win32")
        silent! %s/\r//g
        silent! normal! gg5dd
    endif
    silent g/\vrelevant-\d+ /s///
    silent! g/^Synonyms/+;/^$/s/, $//
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
    vnoremap <unique> <LocalLeader>K y:Thesaurus <C-r>"<CR>
endif

command! OnlineThesaurusCurrentWord :call <SID>Lookup(expand('<cword>'))
command! OnlineThesaurusLookup :call <SID>Lookup(expand('<cword>'))
command! -nargs=1 Thesaurus :call <SID>Lookup(<q-args>)

let &cpo = s:save_cpo
let &shell = s:save_shell
