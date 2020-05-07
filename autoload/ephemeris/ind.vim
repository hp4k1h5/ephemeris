
function! ephemeris#ind#create_index()

  " be in calendar_diary dir
  if expand('%:p:h') !=? expand(g:calendar_diary)
    execute 'cd ' expand(g:calendar_diary)
  endif
  " be in diary/index.md
  let l:ifn = expand(g:calendar_diary).'/index.md'
  if expand('%') !=? l:ifn
    echom "noda same you idyit"
    execute 'normal! :vsplit '.l:ifn
    " execute 'normal! ggdGi## Diary Entries\r' 
  endif
endfunction
" noremap <leader>dci    ggdGi## Diary Entries<CR><C-r>=glob('**/*')<CR><ESC>:w<CR>
" noremap <leader>dct    :call CopyTODOs()<CR>


