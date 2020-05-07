function! ephemeris#ind#goto_index()
  let l:ifn = expand(g:calendar_diary).'/index.md'
  if expand('%') !=? l:ifn
    let l:wn = bufwinnr(l:ifn)
    if bufexists(l:ifn) && l:wn > -1
        execute l:wn."wincmd w"
      else
        execute 'vsplit 'l:ifn
    endif
  endif

  " be in calendar_diary dir
  if expand('%:p:h') !=? expand(g:calendar_diary)
    execute 'cd ' expand(g:calendar_diary)
  endif
endfunction

function! ephemeris#ind#create_index()
  " be in diary/index.md
  call ephemeris#ind#goto_index()
  " clear index
  execute 'normal! ggdG'

  " add headers 
  call append('$', '## Diary Entries')
  call append('$', '**found in '.expand(g:calendar_diary).'**')
  call append('$', '[toc]')
  " add entries
  " TODO: add custom sort
  for item in glob('**/*', 0, 1)
    if item ==? 'index.md'
      continue
    endif
    let l:l = split(item, '/')
    if len(l:l) == 1
      let item = '- ### '.item
    elseif len(l:l) == 2
      let item = '  - ##### '.item
    else
      let item =  '    - ['.item.']('.expand(g:calendar_diary).'/'.item.')'
    endif
    call append('$', item)
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
