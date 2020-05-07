
function! ephemeris#ind#create_index()
  " be in calendar_diary dir
  if expand('%:p:h') !=? expand(g:calendar_diary)
    execute 'cd ' expand(g:calendar_diary)
  endif

  " be in diary/index.md
  let l:ifn = expand(g:calendar_diary).'/index.md'
  if expand('%') !=? l:ifn
    let l:wn = win_findbuf(bufnr(l:ifn))
    if bufexists(l:ifn) && len(l:wn) > 0
        echom "YO"
        echom winbufnr(l:wn[0])
        execute 'b '.winbufnr(l:wn[0])
      else
        execute 'vsplit 'l:ifn
    endif
  endif

  return 0
  " clear index
  execute 'normal! ggdG'

  " recreate
  call append('$', '## Diary Entries')
  call append('$', '##### found in '.expand(g:calendar_diary))

  " add entries
  for item in glob('**/*', 0, 1)
    call append('$', '- '.item)
  endfor

  execute 'w'
endfunction


" simple remap to dump text
" noremap <leader>dci    ggdGi## Diary Entries<CR><C-r>=glob('**/*')<CR><ESC>:w<CR>

" hidden layer formatting 
    " let l:l = split(item, '/')
    " if len(l:l) > 1
    "   let l:l[0] = '../ '
    " endif
    " if len(l:l) == 3
    "   let l:l[1] = '../'
    " endif
    " call append('$', join(l:l, ''))
