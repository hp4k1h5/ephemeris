" vim:tabstop=2:shiftwidth=2:expandtab:textwidth=80
" Filename: autoload/ind.vim
" Description: everything concerning the diary index
" Home: https://github.com/HP4k1h5/ephemeris/
" Purpose: diary index utility functions 

""
" @public
" Find or create, and go to diary index file. Index located at
" @setting(g:ephemeris_diary)/index.md
function! ephemeris#ind#goto_index()
  " find/create and goto index
  let l:ifn = expand(g:ephemeris_diary).'/index.md'
  if expand('%') !=# l:ifn
    let l:wn = bufwinnr(l:ifn)
    if bufexists(l:ifn) && l:wn > -1
        execute l:wn.'wincmd w'
      else
        execute 'vsplit '.l:ifn
    endif
  endif

  " be in ephemeris_diary dir
    execute 'cd '.expand(g:ephemeris_diary)
endfunction

" Formatting:
" {# Index Title}    
" [toc]
" {### YYYY}
" {#### MM}
" {[DD.md](DD.md)}

""
" @public
" Create an index of diary entries found recursively under the
" @setting(g:ephemeris_diary) directory at `g:ephemeris_diary/index.md`, and
" open the index in a vertical split. Entries are formatted as markdown links.
function! ephemeris#ind#create_index()
  " be in diary/index.md
  call ephemeris#ind#goto_index()
  " clear buffer 
  execute 'normal! ggdG'

  " add headers 
  call append(0, '# Diary Entries')
  call append('$', '**found in '.expand(g:ephemeris_diary).'/**')
  call append('$', '[toc]')
  " add entries
  " TODO: add custom sort
  for item in glob('**/*', 0, 1)
    if item ==# 'index.md'
      continue
    endif
    let l:l = split(item, '/')
    if len(l:l) == 1
      let item = '### '.item
    elseif len(l:l) == 2
      let item = '##### '.item
    else
      let item =  '- ['.item.']('.item.')'
    endif
      call append('$', item)
  endfor

  " save to disk
  execute 'w'
endfunction
